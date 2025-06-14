import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/profile_patient/data/models/update_patient_model.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/update_patient_bloc/update_patient_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/update_therapist_bloc/update_therapist_bloc.dart';
import 'package:go_router/go_router.dart';

class PatientOnboardingSreen extends StatefulWidget {
  final bool isFromSignUp;

  const PatientOnboardingSreen({super.key, required this.isFromSignUp});

  @override
  _PatientOnboardingSreenState createState() => _PatientOnboardingSreenState();
}

class _PatientOnboardingSreenState extends State<PatientOnboardingSreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? gender;
  String? preferredModality;
  String? preferredGender;
  String preferredLanguage = 'English';
  List<String> preferredDays = [];
  String? preferredMode;
  List<String> preferredSpecialties = [];

  final List<String> genderOptions = ['Male', 'Female', 'Non-binary'];
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
     BlocProvider.of<UpdatePatientBloc>(context).add(UpdatePatientLoadEvent(patient: UpdatePatientModel(
      gender: gender,
      preferredModality: preferredModality,
      preferredGender: preferredGender != null ? [preferredGender!] : null,
      preferredLanguage: [ preferredLanguage ?? ""],
      preferredDays: preferredDays,
      preferredMode: preferredMode != null ? [preferredMode!] : null,
      preferredSpecialties: preferredSpecialties,
    )));

    final onboardingData = {
      'gender': gender,
      'preferred_modality': preferredModality,
      'preferred_gender': preferredGender,
      'preferred_language': preferredLanguage,
      'preferred_days': preferredDays,
      'preferred_mode': preferredMode,
      'preferred_specialties': preferredSpecialties,
    };
    print('Onboarding Data: $onboardingData');
    widget.isFromSignUp
        ? context.goNamed('login')
        : context.goNamed('home', extra: {'index': 0});
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
                    title: 'How would you like therapy?',
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Preferred Modality'),
                      value: preferredModality,
                      items: modalityOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (value) => setState(() => preferredModality = value),
                    ),
                  ),
                  _buildStep(
                    title: 'Therapist Gender Preference',
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Preferred Therapist Gender'),
                      value: preferredGender,
                      items: genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (value) => setState(() => preferredGender = value),
                    ),
                  ),
                  _buildStep(
                    title: 'Language Preference',
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Preferred Language'),
                      value: preferredLanguage,
                      items: languageOptions.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                      onChanged: (value) => setState(() => preferredLanguage = value ?? "English"),
                    ),
                  ),
                  _buildStep(
                    title: 'When are you available?',
                    child: Wrap(
                      spacing: 8,
                      children: daysOptions.map((day) {
                        return FilterChip(
                          label: Text(day),
                          selected: preferredDays.contains(day),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                preferredDays.add(day);
                              } else {
                                preferredDays.remove(day);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  _buildStep(
                    title: 'How do you prefer to connect?',
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Preferred Mode'),
                      value: preferredMode,
                      items: modeOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                      onChanged: (value) => setState(() => preferredMode = value),
                    ),
                  ),
                  _buildStep(
                    title: 'What do you need help with?',
                    child: Wrap(
                      spacing: 8,
                      children: specialtyOptions.map((spec) {
                        return FilterChip(
                          label: Text(spec),
                          selected: preferredSpecialties.contains(spec),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                preferredSpecialties.add(spec);
                              } else {
                                preferredSpecialties.remove(spec);
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