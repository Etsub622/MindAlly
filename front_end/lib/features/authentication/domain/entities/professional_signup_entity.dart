import 'package:equatable/equatable.dart';

class ProfessionalSignupEntity extends Equatable {
  final String id;
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final String specialization;
  final String certificate;

  const ProfessionalSignupEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.specialization,
    required this.certificate,
  });
  @override
  List<Object> get props {
    return [
      id,
      email,
      password,
      fullName,
      phoneNumber,
      specialization,
      certificate,
    ];
  }
}
