import torch
import torch.nn as nn
import pandas as pd
import numpy as np
import joblib
import json
import sys
import os

# Define the LogisticRegressionTorch class
class LogisticRegressionTorch(nn.Module):
    def __init__(self, input_dim):
        super(LogisticRegressionTorch, self).__init__()
        self.linear = nn.Linear(input_dim, 1)
    
    def forward(self, x):
        return torch.sigmoid(self.linear(x))

script_dir = os.path.dirname(os.path.abspath(__file__))
scaler_path = os.path.join(script_dir, 'model', 'scaler.pkl')
model_path = os.path.join(script_dir, 'model', 'logreg_rl_model.pth')
scaler = joblib.load(scaler_path)
input_dim = 7
model = LogisticRegressionTorch(input_dim)
model.load_state_dict(torch.load(model_path))
model.eval()

def create_features(user, therapist):
    features = []
    features.append(1 if user['preferred_modality'] == therapist['modality'] else 0)
    features.append(1 if user['preferred_gender'] == therapist['gender'] else 0)
    user_langs = user['preferred_language'] if isinstance(user['preferred_language'], list) and len(user['preferred_language']) > 0 else []
    therapist_langs = therapist['language'] if isinstance(therapist['language'], list) and len(therapist['language']) > 0 else [therapist['language']] if therapist['language'] else []
    features.append(1 if any(lang in user_langs for lang in therapist_langs) else 0)
    features.append(1 if user['preferred_mode'] == therapist['mode'] else 0)
    
    user_days = set(user['preferred_days']) if isinstance(user['preferred_days'], list) and len(user['preferred_days']) > 0 else set()
    therapist_days = set(therapist['available_days'].split(',')) if pd.notna(therapist['available_days']) and len(therapist['available_days'].split(',')) > 0 else set()
    features.append(1 if len(user_days.intersection(therapist_days)) > 0 else 0)
    
    user_specialties = set(user['preferred_specialties']) if isinstance(user['preferred_specialties'], list) and len(user['preferred_specialties']) > 0 else set()
    therapist_specialties = set(therapist['specialties'].split(',')) if pd.notna(therapist['specialties']) and len(therapist['specialties'].split(',')) > 0 else set()
    features.append(len(user_specialties.intersection(therapist_specialties)))
    features.append(therapist['experience_years'] if pd.notna(therapist['experience_years']) else 0)
    return np.array(features)

def suggest_top_5_therapists(user_data, therapists_data, scaler, model):
    scores = []
    therapist_ids = []
    
    for therapist in therapists_data:
        therapist_mapped = {
            'id': str(therapist['_id']),
            'therapist_name': therapist['FullName'],
            'modality': therapist.get('modality', ''),
            'gender': therapist.get('gender', ''),
            'language': therapist.get('language', ''),
            'available_days': therapist.get('available_days', ''),
            'mode': therapist.get('mode', ''),
            'specialties': therapist.get('AreaofSpecification', ''),
            'experience_years': therapist.get('experience_years', 0)
        }
        features = create_features(user_data, therapist_mapped)
        features_scaled = scaler.transform([features])[0]
        features_tensor = torch.tensor(features_scaled, dtype=torch.float32)
        with torch.no_grad():
            prob = model(features_tensor).item()
        scores.append(prob)
        therapist_ids.append(therapist_mapped['id'])
    
    top_indices = np.argsort(scores)[-5:][::-1]
    top_therapists = [
        {
            "therapist_id": therapist_ids[i],
            "therapist_name": therapists_data[i]['FullName'],
            "score": scores[i]
        }
        for i in top_indices
    ]
    return top_therapists

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"error": "Output file path not provided"}), file=sys.stderr)
        sys.exit(1)
    
    output_file = sys.argv[1]  # Get the output file path from command-line argument
    
    for line in sys.stdin:
        try:
            data = json.loads(line.strip())
            user_data = data['user']
            therapists_data = data['therapists']
            top_5 = suggest_top_5_therapists(user_data, therapists_data, scaler, model)
            # Write the result to the specified output file
            with open(output_file, 'w') as f:
                json.dump(top_5, f)
        except json.JSONDecodeError as e:
            with open(output_file, 'w') as f:
                json.dump({"error": f"Invalid JSON input: {str(e)}"}, f)
        except Exception as e:
            with open(output_file, 'w') as f:
                json.dump({"error": str(e)}, f)