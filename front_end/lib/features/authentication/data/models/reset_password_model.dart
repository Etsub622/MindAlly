import 'package:front_end/features/authentication/domain/entities/reset_password.dart';
class ResetPasswordModel extends ResetPasswordEntity {
  ResetPasswordModel({
    required super.resetToken,
    required super.newPassword,
  });
  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      resetToken: json['resetToken'],
      newPassword: json['newPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resetToken': super.resetToken,
      'newPassword': super.newPassword,
    };
  }
}
