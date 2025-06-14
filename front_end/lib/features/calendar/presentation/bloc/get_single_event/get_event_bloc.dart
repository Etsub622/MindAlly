

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/domain/usecase/get_single_scheduled_event_usecase.dart';

part 'get_event_event.dart';
part 'get_event_state.dart';

class GetScheduledEventBloc extends Bloc<GetScheduledEventEvent, GetScheduledEventState> {
  final GetSingleEventScheduleUsecase getSingleScheduledEventUsecase;

  GetScheduledEventBloc({
    required this.getSingleScheduledEventUsecase,
  }) : super(GetScheduledEventInitial()) {
    on<GetScheduledEventEvent>(_onGetScheduledEvent);
  }

  Future<void> _onGetScheduledEvent(
      GetScheduledEventEvent event, Emitter<GetScheduledEventState> emit) async {
    emit(GetScheduledEventLoading());
    final failureOrGet = await getSingleScheduledEventUsecase(event.calendarId);

    return failureOrGet.fold(
      (failure) => emit(GetScheduledEventError(errorMessage: failure.toString())),
      (event) => emit(GetScheduledEventLoaded(events: event)),
    );
  }

}