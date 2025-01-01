import 'package:front_end/features/authentication/domain/entities/student_data.dart';

class StudentResponseModel extends StudentDataResponse {
  const StudentResponseModel({
    required super.token,
    required super.studentData,
  });

  factory StudentResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentResponseModel(
      token: json["token"],
      studentData: StudentDataModel.fromJson(json["dataResponse"]),
    );
  }
}


class StudentDataModel extends StudentUserEntity {
  StudentDataModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.password,
    required super.bio,
    required super.gender,
    required super.phoneNumber,
    required super.profileImage,
    required super.role,
  });

  factory StudentDataModel.fromJson(Map<String, dynamic> json) {
    return StudentDataModel(
      id: json['id'],
      fullName: json['fullName']?? "",
      email: json['email'] ?? "",
      password: json['password'] ?? "",
      bio: json['bio'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      gender: json['gender'] ?? "",
      profileImage: json['profileImage'] ?? "",
      role: json['role'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'bio': bio,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'profileImage': profileImage,
      'role': role,
    };
  }
}
