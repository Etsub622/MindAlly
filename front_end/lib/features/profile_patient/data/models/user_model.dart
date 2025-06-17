

import 'package:front_end/features/profile_patient/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  const UserModel({
    required  super.id,
    required  super.name,
    required  super.email,
    required  super.hasPassword,
    required  super.role,
    required super.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['FullName'],
      email: json['Email'],
      role: json['Role'],
      hasPassword: json['Password'] != null,
      profilePicture: json['profilePicture']
    );
  }

  factory UserModel.fromLocalCachedJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] ?? '',
        email: json['email'] ?? '',
        name: json["name"] ?? false,
        hasPassword: json['password'] ?? false,
        role: json['role'] ?? "0",
        profilePicture: json['profilePicture']
        
    );}

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'FullName': name,
      'Email': email,
      'hasPassword': hasPassword,
      'Role': role,
      'profilePicture': profilePicture,
    };
  }
}