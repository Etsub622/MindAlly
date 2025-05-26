

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/domain/usecase/update_scheduled_event_usecase.dart';

part 'update_events_event.dart';
part 'update_events_state.dart';

class UpdateScheduledEventsBloc extends Bloc<UpdateScheduledEventsEvent, UpdateScheduledEventsState> {
  final UpdateScheduledEventUsecase updateScheduledEventsUsecase;

  UpdateScheduledEventsBloc({
    required this.updateScheduledEventsUsecase,
  }) : super(UpdateScheduledEventsInitial()) {
    on<UpdateScheduledEventsEvent>(_onUpdateScheduledEvents);
  }

  Future<void> _onUpdateScheduledEvents(
      UpdateScheduledEventsEvent event, Emitter<UpdateScheduledEventsState> emit) async {
    emit(UpdateScheduledEventsLoading());

    final failureOrUpdate = await updateScheduledEventsUsecase(event.eventEntity);

    return failureOrUpdate.fold(
      (failure) => emit(UpdateScheduledEventsError(errorMessage: failure.toString())),
      (events) => emit(UpdateScheduledEventsLoaded()),
    );
  }

}