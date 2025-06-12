// lib/features/approve_therapist/presentation/bloc/verify_event.dart
part of 'verify_bloc.dart';

abstract class VerifyEvent {}

class LoadTherapistsEvent extends VerifyEvent {}

class ApproveTherapistEvent extends VerifyEvent {
  final String id;

  ApproveTherapistEvent({required this.id});
}

class RejectTherapistEvent extends VerifyEvent {
  final String id;
  final String reason;

  RejectTherapistEvent({required this.id, required this.reason});
}
