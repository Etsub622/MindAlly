

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/domain/usecase/get_scheduled_event_usecase.dart';

part 'get_events_event.dart';
part 'get_events_state.dart';

class GetScheduledEventsBloc extends Bloc<GetScheduledEventsEvent, GetScheduledEventsState> {
  final GetEventScheduleUsecase getScheduledEventsUsecase;

  GetScheduledEventsBloc({
    required this.getScheduledEventsUsecase,
  }) : super(GetScheduledEventsInitial()) {
    on<GetScheduledEventsEvent>(_onGetScheduledEvents);
  }

  Future<void> _onGetScheduledEvents(
      GetScheduledEventsEvent event, Emitter<GetScheduledEventsState> emit) async {
    emit(GetScheduledEventsLoading());
    
    final failureOrGet = await getScheduledEventsUsecase(NoParams());

    return failureOrGet.fold(
      (failure) => emit(GetScheduledEventsError(errorMessage: failure.toString())),
      (events) => emit(GetScheduledEventsLoaded(events: events)),
    );
  }

}