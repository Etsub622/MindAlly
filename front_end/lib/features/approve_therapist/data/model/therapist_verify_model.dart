import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';

class TherapistVerifyModel extends TherapistVerifyEntity {
  TherapistVerifyModel({
    required super.id,
    required super.name,
    required super.email,
    super.profilePicture,
    required super.certificate,
    required super.specialization,
  });

  factory TherapistVerifyModel.fromJson(Map<String, dynamic> json) {
    return TherapistVerifyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
      certificate: json['certificate'] ?? '',
      specialization: json['specialization'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': super.id,
      'name': super.name,
      'email': super.email,
      'profilePicture': super.profilePicture,
      'certificate': super.certificate,
      'specialization': super.specialization,
    };
  }

  TherapistVerifyEntity toEntity() {
    return TherapistVerifyEntity(
      id: super.id,
      name: super.name,
      email: super.email,
      profilePicture: super.profilePicture,
      certificate: super.certificate,
      specialization: super.specialization,
    );
  }
  
  
} 