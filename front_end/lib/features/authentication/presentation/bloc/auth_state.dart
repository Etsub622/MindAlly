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

final class AuthOtpSent extends AuthState {
  final String message;

  const AuthOtpSent(this.message);
}

final class AuthOtpVerified extends AuthState {
  final String message;

  const AuthOtpVerified(this.message);
}

final class AuthOtpSendError extends AuthState {
  final String message;

  const AuthOtpSendError(this.message);
}

final class AuthOtpVerifyError extends AuthState {
  final String message;

  const AuthOtpVerifyError(this.message);
}






