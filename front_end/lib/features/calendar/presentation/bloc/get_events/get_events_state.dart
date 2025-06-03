

part of 'get_events_bloc.dart';

sealed class GetScheduledEventsState {}

class GetScheduledEventsInitial extends GetScheduledEventsState {}

class GetScheduledEventsLoading extends GetScheduledEventsState {}

class GetScheduledEventsLoaded extends GetScheduledEventsState {
  final List<EventEntity> events;

  GetScheduledEventsLoaded({required this.events});
}

class GetScheduledEventsError extends GetScheduledEventsState {
  final String errorMessage;

  GetScheduledEventsError({required this.errorMessage});
}