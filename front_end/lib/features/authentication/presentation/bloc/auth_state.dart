part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

final class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);
}

final class LoginSuccess extends AuthState {
    final StudentResponseModel response;

  const LoginSuccess(this.response);
}

final class AuthOtpSent extends AuthState {
  final String message;

  const AuthOtpSent(this.message);
}

final class AuthOtpVerified extends AuthState {
  final String resetToken;

  const AuthOtpVerified(this.resetToken);
}

final class AuthOtpSendError extends AuthState {
  final String message;

  const AuthOtpSendError(this.message);
}

final class AuthOtpVerifyError extends AuthState {
  final String message;

  const AuthOtpVerifyError(this.message);
}

final class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess(this.message);
}

final class ResetPasswordError extends AuthState {
  final String message;

  const ResetPasswordError(this.message);
}


final class StudentDataLoaded extends AuthState {
  final StudentUserEntity studentData;

  const StudentDataLoaded(this.studentData);
}

final class StudentDataError extends AuthState {
  final String message;

  const StudentDataError(this.message);
}

final class studentDataLoaded extends AuthState {
  final StudentUserEntity studentData;

  const studentDataLoaded(this.studentData);
}

enum AuthStatus { loaded, loading, error }

class UserLogoutState extends AuthState {
  final String message;
  final AuthStatus status;

  UserLogoutState({required this.message, required this.status});
  @override
  List<Object> get props => [status];
}



