

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/domain/usecase/add_event_schedule_usecase.dart';

part 'add_events_event.dart';
part 'add_events_state.dart';

class AddScheduledEventsBloc extends Bloc<AddScheduledEventsEvent, AddScheduledEventsState> {
  final AddEventScheduleUsecase addScheduledEventsUsecase;

  AddScheduledEventsBloc({
    required this.addScheduledEventsUsecase,
  }) : super(AddScheduledEventsInitial()) {
    on<AddScheduledEventsEvent>(_onAddScheduledEvents);
  }

  Future<void> _onAddScheduledEvents(
      AddScheduledEventsEvent event, Emitter<AddScheduledEventsState> emit) async {
    emit(AddScheduledEventsLoading());

    final failureOrAdd = await addScheduledEventsUsecase(event.eventEntity);

    return failureOrAdd.fold(
      (failure) => emit(AddScheduledEventsError(errorMessage: failure.toString())),
      (events) => emit(AddScheduledEventsLoaded()),
    );
  }

}