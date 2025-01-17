import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String id;
  final String email;
  final String password;

  const LoginEntity({required this.id, required this.email, required this.password});

  @override
  List<Object> get props {
    return [
      email,
      password,
    ];
  }
}
