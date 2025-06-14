// lib/features/approve_therapist/domain/entity/therapist_verify_entity.dart
import 'package:equatable/equatable.dart';

class TherapistVerifyEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String certificate;
  final String specialization;

  const TherapistVerifyEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.certificate,
    required this.specialization,
  });

  @override
  List<Object?> get props =>
      [id, fullName, email, role, certificate, specialization];
}
