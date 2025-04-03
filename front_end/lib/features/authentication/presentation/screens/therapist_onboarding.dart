import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/update_therapist_bloc/update_therapist_bloc.dart';
import 'package:go_router/go_router.dart';

class TherapistOnboardingScreen extends StatefulWidget {

  const TherapistOnboardingScreen({super.key});

  @override
  _TherapistOnboardingScreenState createState() => _TherapistOnboardingScreenState();
}

class _TherapistOnboardingScreenState extends State<TherapistOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Therapist preferences
  String? gender;
  String? modality;
  String? language;
  List<String> availableDays = [];
  String? mode;
  String? experienceYears;
  List<String> specialties = [];

  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> modalityOptions = [
    "Adlerian Therapy",
    "Cognitive Analytic Therapy (CAT)",
    "Cognitive Behavioral Therapy (CBT)",
    "Cognitive Therapy",
    "Dialectical Behavior Therapy (DBT)",
    "Emotionally Focused Therapy (EFT)",
    "Existential Psychotherapy",
    "Gestalt Therapy",
    "Humanistic Therapy",
    "Integrative Counselling",
    "Jungian Therapy",
    "Person-Centred Therapy",
    "Psychoanalysis",
    "Psychodynamic Psychotherapy",
    "Solution-Focused Brief Therapy (SFBT)",
    "Transactional Analysis (TA)",
    "Acceptance and Commitment Therapy (ACT)",
    "Mindfulness-Based Cognitive Therapy (MBCT)",
    "Narrative Therapy",
    "Schema Therapy",
    "Interpersonal Psychotherapy (IPT)"];
  final List<String> languageOptions = ['Amharic', 'English', 'Oromo', 'Tigrinya'];
  final List<String> daysOptions = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final List<String> modeOptions = ["Video", "Audio"];
  final List<String> specialtyOptions = [
    "Anxiety",                
    "Depression",             
    "Trauma",                
    "Relationships",          
    "OCD",                   
    "PTSD",                  
    "BPD",                
    "Stress",               
    "Test Anxiety",           
    "Substance Use",         
    "Suicidal Ideation",      
    "Sleep Disorders",         
    "Adjustment Disorders",    
    "Social Anxiety",         
    "Panic Disorders",       
    "Generalized Anxiety Disorder (GAD)",
    "Mood Disorders",        
    "Academic Burnout",       
    "Family Conflict",       
    "Self-Esteem Issues",      
    "Loneliness",           
    "Eating Disorders",       
    "ADHD",                   
    "Grief and Loss",        
    "Cultural Identity Stress"
    "Financial Stress",      
    "Interpersonal Violence", 
    "Somatic Complaints" ];

  void _submit() {
    BlocProvider.of<UpdateTherapistBloc>(context).add(UpdateTherapistLoadEvent(therapist: UpdateTherapistModel(
      gender: gender,
      modality: modality,
      language: language != null ? [language!] : [],
      availableDays: availableDays,
      mode: mode != null ? [mode!] : [],
      experienceYears: experienceYears != null ? int.tryParse(experienceYears!) : null,
      specialities: specialties,

    )));
    final onboardingData = {
      'gender': gender,
      'modality': modality,
      'language': language,
      'available_days': availableDays,
      'mode': mode,
      'experience_years': experienceYears,
      'specialties': specialties,
    };
    print('Therapist Onboarding Data: $onboardingData');
    context.push(AppPath.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildStep(
                    title: 'Tell us about yourself',
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Gender'),
                      value: gender,
                      items: genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (value) => setState(() => gender = value),
                    ),
                  ),
                  _buildStep(
                    title: 'Your Therapy Style',
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Modality'),
                      value: modality,
                      items: modalityOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (value) => setState(() => modality = value),
                    ),
                  ),
                  _buildStep(
                    title: 'Language Proficiency',
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Language'),
                      value: language,
                      items: languageOptions.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                      onChanged: (value) => setState(() => language = value),
                    ),
                  ),
                  _buildStep(
                    title: 'Availability',
                    child: Wrap(
                      spacing: 8,
                      children: daysOptions.map((day) {
                        return FilterChip(
                          label: Text(day),
                          selected: availableDays.contains(day),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                availableDays.add(day);
                              } else {
                                availableDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  _buildStep(
                    title: 'Preferred Mode',
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Mode'),
                      value: mode,
                      items: modeOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (value) => setState(() => mode = value),
                    ),
                  ),
                  _buildStep(
                    title: 'Years of Experience',
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Experience (Years)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => experienceYears = value,
                    ),
                  ),
                  _buildStep(
                    title: 'Your Specialties',
                    child: Wrap(
                      spacing: 8,
                      children: specialtyOptions.map((spec) {
                        return FilterChip(
                          label: Text(spec),
                          selected: specialties.contains(spec),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                specialties.add(spec);
                              } else {
                                specialties.remove(spec);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    ElevatedButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: const Text('Back'),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(7, (index) => _buildDot(index)),
                  ),
                  ElevatedButton(
                    onPressed: _currentPage == 6 ? _submit : () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: Text(_currentPage == 6 ? 'Finish' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall).animate().fadeIn(),
          const SizedBox(height: 20),
          child.animate().slideY(begin: 0.5, end: 0, duration: 500.ms),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CircleAvatar(
        radius: 4,
        backgroundColor: _currentPage == index ? Colors.teal : Colors.grey,
      ),
    );
  }
}