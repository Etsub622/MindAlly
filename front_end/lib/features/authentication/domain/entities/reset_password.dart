import 'package:equatable/equatable.dart';

class ResetPasswordEntity extends Equatable {
  final String id;
  final String password;
  const ResetPasswordEntity({
    required this.id,
    required this.password,
  });

  @override
  List<Object> get props => [id, password];

}

