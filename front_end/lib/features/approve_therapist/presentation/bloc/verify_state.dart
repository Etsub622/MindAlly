part of 'verify_bloc.dart';

@immutable
sealed class VerifyState {}

final class VerifyInitial extends VerifyState {}

final class VerifyLoading extends VerifyState {}

final class VerifyLoaded extends VerifyState {
  final List<TherapistVerifyEntity> therapists;

  VerifyLoaded({required this.therapists});
}

final class VerifyActionSuccess extends VerifyState {
  final String message;

  VerifyActionSuccess({required this.message});
}

final class VerifyError extends VerifyState {
  final String message;

  VerifyError({required this.message});
}
