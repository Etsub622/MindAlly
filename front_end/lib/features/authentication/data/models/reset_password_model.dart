import 'package:front_end/features/authentication/domain/entities/reset_password.dart';
class ResetPasswordModel extends ResetPasswordEntity {
  ResetPasswordModel({
    required super.id,
    required super.password,
  });
  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      id: json['id'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'password': super.password,
    };
  }
}
