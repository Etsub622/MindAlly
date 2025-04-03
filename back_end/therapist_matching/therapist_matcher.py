import torch
import torch.nn as nn
import pandas as pd
import numpy as np
import joblib
import json
import sys

# Define the LogisticRegressionTorch class
class LogisticRegressionTorch(nn.Module):
    def __init__(self, input_dim):
        super(LogisticRegressionTorch, self).__init__()
        self.linear = nn.Linear(input_dim, 1)
    
    def forward(self, x):
        return torch.sigmoid(self.linear(x))

# Load scaler and model
scaler = joblib.load('/Users/etsubdink/MindAlly/back_end/therapist_matching/model/scaler.pkl')
input_dim = 7
model = LogisticRegressionTorch(input_dim)
model.load_state_dict(torch.load('/Users/etsubdink/MindAlly/back_end/therapist_matching/model/logreg_rl_model.pth'))
model.eval()

# Create features function
def create_features(user, therapist):
    features = []
    features.append(1 if user['preferred_modality'] == therapist['modality'] else 0)
    features.append(1 if user['preferred_gender'] == therapist['gender'] else 0)
    features.append(1 if any(lang in user['preferred_language'] for lang in (therapist['language'] if isinstance(therapist['language'], list) else [therapist['language']])) else 0)
    features.append(1 if user['preferred_mode'] == therapist['mode'] else 0)
    
    user_days = set(user['preferred_days']) if user['preferred_days'] else set()
    therapist_days = set(therapist['available_days'].split(',')) if pd.notna(therapist['available_days']) else set()
    features.append(1 if len(user_days.intersection(therapist_days)) > 0 else 0)
    
    user_specialties = set(user['preferred_specialties']) if user['preferred_specialties'] else set()
    therapist_specialties = set(therapist['specialties'].split(',')) if pd.notna(therapist['specialties']) else set()
    features.append(len(user_specialties.intersection(therapist_specialties)))
    features.append(therapist['experience_years'] if pd.notna(therapist['experience_years']) else 0)
    return np.array(features)

# Suggest top 5 therapists
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
    for line in sys.stdin:
        try:
            data = json.loads(line.strip())
            # print(data)
            user_data = data['user']
            therapists_data = data['therapists']
            top_5 = suggest_top_5_therapists(user_data, therapists_data, scaler, model)
            print(json.dumps(top_5))
            sys.stdout.flush()
        except Exception as e:
            print(json.dumps({"error": str(e)}))
            sys.stdout.flush()

