

part of 'update_events_bloc.dart';

sealed class UpdateScheduledEventsState {}

class UpdateScheduledEventsInitial extends UpdateScheduledEventsState {}

class UpdateScheduledEventsLoading extends UpdateScheduledEventsState {}

class UpdateScheduledEventsLoaded extends UpdateScheduledEventsState {}

class UpdateScheduledEventsError extends UpdateScheduledEventsState {
  final String errorMessage;

  UpdateScheduledEventsError({required this.errorMessage});
}