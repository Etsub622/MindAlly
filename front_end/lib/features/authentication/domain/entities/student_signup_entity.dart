import 'package:equatable/equatable.dart';

class StudentSignupEntity extends Equatable {
  final String id;
  final String email;
  final String password;

  final String fullName;
  final String phoneNumber;
  final String college;

  const StudentSignupEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.college,
  });
  @override
  List<Object> get props {
    return [
      id,
      email,
      password,
      fullName,
      phoneNumber,
      college,
    ];
  }
}
