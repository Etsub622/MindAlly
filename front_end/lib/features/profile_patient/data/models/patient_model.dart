

import 'package:front_end/features/profile_patient/domain/entities/patient_entity.dart';

class PatientModel extends PatientEntity {
  const PatientModel({
    required  super.id,
    required  super.name,
    required  super.email,
    required  super.hasPassword,
    required  super.role,
    required super.collage,
        });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id'],
      name: json['FullName'],
      email: json['Email'],
      role: json['Role'],
      hasPassword: json['Password'] != null,
      collage: json[' Collage'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'FullName': name,
      'Email': email,
      'hasPassword': hasPassword,
      'Role': role,
      'Collage': collage,
    };
  }
    }