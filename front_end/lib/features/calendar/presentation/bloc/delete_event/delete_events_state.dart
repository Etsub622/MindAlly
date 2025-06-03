part of 'delete_events_bloc.dart';



sealed class DeleteScheduledEventsState {}

class DeleteScheduledEventsInitial extends DeleteScheduledEventsState {}

class DeleteScheduledEventsLoading extends DeleteScheduledEventsState {}

class DeleteScheduledEventsLoaded extends DeleteScheduledEventsState {}

class DeleteScheduledEventsError extends DeleteScheduledEventsState {
  final String errorMessage;

  DeleteScheduledEventsError({required this.errorMessage});
}