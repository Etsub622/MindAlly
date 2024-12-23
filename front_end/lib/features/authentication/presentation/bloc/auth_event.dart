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

final class LoginEvent extends AuthEvent{
  final LoginEntity loginEntity;
  const LoginEvent({required this.loginEntity});
}

final class sendOtpEvent extends AuthEvent{
  final String phoneNumber;
  const sendOtpEvent({required this.phoneNumber});
}

final class verifyOtpEvent extends AuthEvent{
  final String otp;
  final String phoneNumber;
  const verifyOtpEvent({required this.otp, required this.phoneNumber});
}


