import 'package:front_end/features/profile_patient/domain/entities/update_patient_entity.dart';

class UpdatePatientModel extends UpdatePatientEntity{
  UpdatePatientModel({
    super.name,
    super.email, 
    super.hasPassword, 
    super.role, 
    super.collage, 
    super.gender, 
    super.preferredModality, 
    super.preferredGender, 
    super.preferredLanguage, 
    super.preferredDays, 
    super.preferredMode, 
    super.preferredSpecialties
  });
      factory UpdatePatientModel.fromJson(Map<String, dynamic> json) {
        return UpdatePatientModel(
          name: json['FullName'],
          email: json['Email'],
          hasPassword: json['Password'] != null,
          role: json['Role'],
          collage: json['Collage'],
          gender: json['gender'],
          preferredModality: json['preferred_modality'],
          preferredGender: json['preferred_gender'],
          preferredLanguage: json['preferred_language'] != null
            ? (json['preferred_language'] as List<dynamic>).map((e) => e.toString()).toList()
            : null,
          preferredDays:json['preferred_days'] != null
            ? (json['preferred_days'] as List<dynamic>).map((e) => e.toString()).toList()
            : null,
          preferredMode: json['preferred_mode'],
          preferredSpecialties: json['preferred_specialties'] != null
              ? (json['preferred_specialties'] as List<dynamic>).map((e) => e.toString()).toList()
              : null,
        );
      }

      Map<String, dynamic> toJson() {
        return {
          'name': name,
          'email': email,
          'hasPassword': hasPassword,
          'role': role,
          'collage': collage,
          'gender': gender,
          'preferred_modality': preferredModality,
          'preferred_gender': preferredGender,
          'preferred_language': preferredLanguage,
          'preferred_days': preferredDays,
          'preferred_mode': preferredMode,
          'preferred_specialties': preferredSpecialties,
        };
      }

      UpdatePatientModel copyWith({
        String? name,
        String? email,
        bool? hasPassword,
        String? role,
        String? collage,
        String? gender,
        String? preferredModality,
        String? preferredGender,
        List<String>? preferredLanguage,
        List<String>? preferredDays,
        String? preferredMode,
        List<String>? preferredSpecialties,
      }) {
        return UpdatePatientModel(
          name: name ?? this.name,
          email: email ?? this.email,
          hasPassword: hasPassword ?? this.hasPassword,
          role: role ?? this.role,
          collage: collage ?? this.collage,
          gender: gender ?? this.gender,
          preferredModality: preferredModality ?? this.preferredModality,
          preferredGender: preferredGender ?? this.preferredGender,
          preferredLanguage: preferredLanguage ?? this.preferredLanguage,
          preferredDays: preferredDays ?? this.preferredDays,
          preferredMode: preferredMode ?? this.preferredMode,
          preferredSpecialties: preferredSpecialties ?? this.preferredSpecialties,
        );
      }
    }