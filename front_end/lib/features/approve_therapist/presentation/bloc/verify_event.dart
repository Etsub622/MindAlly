
part of 'verify_bloc.dart';

@immutable
sealed class VerifyEvent {}

class LoadTherapistsEvent extends VerifyEvent {}

class ApproveTherapistEvent extends VerifyEvent {
  final String id;
  final String? reason;

  ApproveTherapistEvent({required this.id, this.reason});
}

class RejectTherapistEvent extends VerifyEvent {
  final String id;
  final String reason;

  RejectTherapistEvent({required this.id, required this.reason});
}