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
          name: json['name'],
          email: json['email'],
          hasPassword: json['hasPassword'],
          role: json['role'],
          collage: json['collage'],
          gender: json['gender'],
          preferredModality: json['preferredModality'],
          preferredGender: json['preferredGender'],
          preferredLanguage: json['preferredLanguage'],
          preferredDays: json['preferredDays'],
          preferredMode: json['preferredMode'],
          preferredSpecialties: json['preferredSpecialties'],
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
          'preferredModality': preferredModality,
          'preferredGender': preferredGender,
          'preferredLanguage': preferredLanguage,
          'preferredDays': preferredDays,
          'preferredMode': preferredMode,
          'preferredSpecialties': preferredSpecialties,
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