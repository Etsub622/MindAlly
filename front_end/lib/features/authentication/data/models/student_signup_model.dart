import 'package:front_end/features/authentication/domain/entities/student_signup_entity.dart';

class StudentSignupModel extends StudentSignupEntity {
  const StudentSignupModel({
    required super.id,
    required super.email,
    required super.password,
    required super.fullName,
    required super.phoneNumber,
    required super.college,
  });
  factory StudentSignupModel.fromJson(Map<String, dynamic> json) {
    return StudentSignupModel(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      college: json['college'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'email': super.email,
      'password': super.password,
      'fullName': super.fullName,
      'phoneNumber': super.phoneNumber,
      'college': super.college,
    };
  }
}
