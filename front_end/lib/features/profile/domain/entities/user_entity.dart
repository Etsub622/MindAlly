import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.token,
  });

  @override
  List<Object?> get props => [id, name, email, password, role];
}