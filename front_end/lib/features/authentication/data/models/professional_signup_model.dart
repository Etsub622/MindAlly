import 'package:front_end/features/authentication/domain/entities/professional_signup_entity.dart';

class ProfessionalSignupModel extends ProfessionalSignupEntity {
  const ProfessionalSignupModel({
    required super.id,
    required super.email,
    required super.password,
    required super.fullName,
    required super.phoneNumber,
    required super.specialization,
    required super.certificate,
  });
  factory ProfessionalSignupModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalSignupModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      specialization: json['specialization'],
      certificate: json['certificate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'email': super.email,
      'password': super.password,
      'fullName': super.fullName,
      'phoneNumber': super.phoneNumber,
      'specialization': super.specialization,
      'certificate': super.certificate,
    };
  }
}
