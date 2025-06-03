import 'package:front_end/features/authentication/domain/entities/student_data.dart';

class StudentResponseModel extends StudentDataResponse {
  const StudentResponseModel({
    required super.token,
    required super.studentData,
    required super.message,
  });

  factory StudentResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = json["user"];
    if (userJson == null) {
      throw FormatException("User data is null");
    }

    return StudentResponseModel(
      token: json["token"] ?? json["accessToken"] ?? '',
      message: json["message"] ?? '',
      studentData: StudentDataModel.fromJson(userJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': studentData.id,
      'FullName': studentData.fullName,
      'Email': studentData.email,
      'Password': studentData.password,
      'Bio': studentData.bio,
      'PhoneNumber': studentData.phoneNumber,
      'Gender': studentData.gender,
      'ProfileImage': studentData.profileImage,
      'Role': studentData.role,
      'token': token,
      'message': message
    };
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
    required super.collage,
  });

  factory StudentDataModel.fromJson(Map<String, dynamic> json) {
    return StudentDataModel(
      id: json['_id'],
      fullName: json['FullName'] ?? "",
      email: json['Email'] ?? "",
      password: json['Password'] ?? "",
      bio: json['Bio'] ?? "",
      phoneNumber: json['PhoneNumber'] ?? "",
      gender: json['Gender'] ?? "",
      profileImage: json['ProfileImage'] ?? "",
      role: json['Role'] ?? "",
      collage: json['collage'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'FullName': fullName,
      'Email': email,
      'Password': password,
      'Bio': bio,
      'PhoneNumber': phoneNumber,
      'Gender': gender,
      'ProfileImage': profileImage,
      'Role': role,
    };
  }
}
