part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class StudentsignUpEvent extends AuthEvent {
  final StudentSignupEntity studentSignupEntity;
  const StudentsignUpEvent({required this.studentSignupEntity});
}

final class ProfessionalsignUpEvent extends AuthEvent {
  final ProfessionalSignupEntity professionalSignupEntity;
  const ProfessionalsignUpEvent({required this.professionalSignupEntity});
}

final class LoginEvent extends AuthEvent {
  final LoginEntity loginEntity;
  const LoginEvent({required this.loginEntity});
}

final class SendOtpEvent extends AuthEvent {
  final String email;
  const SendOtpEvent({required this.email});
}

final class VerifyOtpEvent extends AuthEvent {
  final String otp;
  final String email;
  const VerifyOtpEvent({required this.otp, required this.email});
}

final class ResetPasswordEvent extends AuthEvent {
  final ResetPasswordEntity resetPasswordEntity;
  ResetPasswordEvent({required this.resetPasswordEntity});
}

final class StudentDataEvent extends AuthEvent {}

final class GetStudentDataEvent extends AuthEvent {
  const GetStudentDataEvent();
}
