import 'package:equatable/equatable.dart';

class TherapistVerifyEntity extends Equatable {
  final String id;
  final String name;
  final String email;

  final String? profilePicture;
  final String certificate;
  final String specialization;

  const TherapistVerifyEntity(
      {required this.id,
      required this.name,
      required this.email,
      this.profilePicture,
      required this.certificate,
      required this.specialization});

  @override
  List<Object?> get props =>
      [id, name, email, certificate, specialization, profilePicture];
}
