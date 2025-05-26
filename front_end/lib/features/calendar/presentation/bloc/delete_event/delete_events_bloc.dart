

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/usecase/delete_scheduled_event_usecase.dart';

part 'delete_events_event.dart';
part 'delete_events_state.dart';

class DeleteScheduledEventsBloc extends Bloc<DeleteScheduledEventsEvent, DeleteScheduledEventsState> {
  final DeleteEventScheduleUsecase deleteScheduledEventsUsecase;

  DeleteScheduledEventsBloc({
    required this.deleteScheduledEventsUsecase,
  }) : super(DeleteScheduledEventsInitial()) {
    on<DeleteScheduledEventsEvent>(_onDeleteScheduledEvents);
  }

  Future<void> _onDeleteScheduledEvents(
      DeleteScheduledEventsEvent event, Emitter<DeleteScheduledEventsState> emit) async {
    emit(DeleteScheduledEventsLoading());
    final failureOrDelete = await deleteScheduledEventsUsecase(event.calendarId);
    return failureOrDelete.fold(
      (failure) => emit(DeleteScheduledEventsError(errorMessage: failure.toString())),
      (events) => emit(DeleteScheduledEventsLoaded()),
    );
  }

}