

part of 'get_event_bloc.dart';

sealed class GetScheduledEventState {}

class GetScheduledEventInitial extends GetScheduledEventState {}

class GetScheduledEventLoading extends GetScheduledEventState {}

class GetScheduledEventLoaded extends GetScheduledEventState {
  final EventEntity? events;

  GetScheduledEventLoaded({required this.events});
}

class GetScheduledEventError extends GetScheduledEventState {
  final String errorMessage;

  GetScheduledEventError({required this.errorMessage});
}