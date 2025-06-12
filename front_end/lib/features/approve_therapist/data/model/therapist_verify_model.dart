// lib/features/approve_therapist/data/model/therapist_verify_model.dart
import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';

class TherapistVerifyModel extends TherapistVerifyEntity {
  const TherapistVerifyModel({
    required String id,
    required String fullName,
    required String email,
    required String role,
    required String certificate,
    required String specialization,
  }) : super(
          id: id,
          fullName: fullName,
          email: email,
          role: role,
          certificate: certificate,
          specialization: specialization,
        );

  factory TherapistVerifyModel.fromJson(Map<String, dynamic> json) {
    return TherapistVerifyModel(
      id: json['_id'] as String,
      fullName: json['FullName'] as String,
      email: json['Email'] as String,
      role: json['Role'] as String,
      certificate: json['Certificate'] as String,
      specialization: json['modality'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'FullName': fullName,
      'Email': email,
      'Role': role,
      'Certificate': certificate,
      'modality': specialization,
    };
  }

  TherapistVerifyEntity toEntity() {
    return TherapistVerifyEntity(
      id: id,
      fullName: fullName,
      email: email,
      role: role,
      certificate: certificate,
      specialization: specialization,
    );
  }
}
