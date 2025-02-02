

import 'package:front_end/features/profile/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  const UserModel({
    required  super.id,
    required  super.name,
    required  super.email,
    required  super.password,
    required  super.role,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      token: json['token'] ?? '',
    );
  }

  factory UserModel.fromLocalCachedJson(Map<String, dynamic> json) {
    return UserModel(
        // profilePicture: json['profile_picture'] ??
        //     "https://storage.googleapis.com/download/storage/v1/b/afrochat-bucket/o/05dc555c03d84f3686b85443c1d10c59_udpoynqd6zs0quuiqfah.png?generation=1725977195569469&alt=media",
        id: json['id'] ?? '',
        email: json['email'] ?? '',
        name: json["name"] ?? false,
        password: json['password'] ?? '',
        role: json['role'] ?? "0",
        token: json['token'] ?? ''
    );}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'token': token,
    };
  }

}