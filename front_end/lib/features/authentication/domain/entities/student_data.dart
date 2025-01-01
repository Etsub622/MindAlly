import 'package:equatable/equatable.dart';
class StudentDataResponse extends Equatable {
  final String token;
  final StudentUserEntity studentData;

  const StudentDataResponse({required this.token, required this.studentData});
  @override
  List<Object?> get props => [token, studentData];
}



class StudentUserEntity extends Equatable {
  final String id;
  final String email;
  final String password;
  final String gender;
  final String phoneNumber;
  final String bio;
  final String profileImage;
  final String role;
  final String fullName;

  StudentUserEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.gender,
    required this.phoneNumber,
    required this.bio,
    required this.profileImage,
    this.role = 'student',
    required this.fullName,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        password,
        profileImage,
        role,
        fullName,
        gender,
        phoneNumber,
        bio
      ];
}
