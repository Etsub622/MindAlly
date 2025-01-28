

import 'package:front_end/features/profile/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  const UserModel({
    required  super.id,
    required  super.name,
    required  super.email,
    required  super.password,
    required  super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
    );
  }

}