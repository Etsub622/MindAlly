

part of 'add_events_bloc.dart';

sealed class AddScheduledEventsState {}

class AddScheduledEventsInitial extends AddScheduledEventsState {}

class AddScheduledEventsLoading extends AddScheduledEventsState {}

class AddScheduledEventsLoaded extends AddScheduledEventsState {}

class AddScheduledEventsError extends AddScheduledEventsState {
  final String errorMessage;

  AddScheduledEventsError({required this.errorMessage});
}