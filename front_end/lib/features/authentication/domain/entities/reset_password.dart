import 'package:equatable/equatable.dart';

class ResetPasswordEntity extends Equatable {
  final String resetToken;
  final String newPassword;
  const ResetPasswordEntity({
    required this.resetToken,
    required this.newPassword,
  });

  @override
  List<Object> get props => [resetToken, newPassword];

}

