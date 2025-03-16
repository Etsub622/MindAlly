

import 'package:front_end/features/profile/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  const UserModel({
    required  super.id,
    required  super.name,
    required  super.email,
    required  super.hasPassword,
    required  super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['FullName'],
      email: json['Email'],
      role: json['Role'],
      hasPassword: json['Password'] != null,
    );
  }

  factory UserModel.fromLocalCachedJson(Map<String, dynamic> json) {
    return UserModel(
        // profilePicture: json['profile_picture'] ??
        //     "https://storage.googleapis.com/download/storage/v1/b/afrochat-bucket/o/05dc555c03d84f3686b85443c1d10c59_udpoynqd6zs0quuiqfah.png?generation=1725977195569469&alt=media",
        id: json['id'] ?? '',
        email: json['email'] ?? '',
        name: json["name"] ?? false,
        hasPassword: json['password'] ?? false,
        role: json['role'] ?? "0",
    );}

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'FullName': name,
      'Email': email,
      'hasPassword': hasPassword,
      'Role': role,
    };
  }
}