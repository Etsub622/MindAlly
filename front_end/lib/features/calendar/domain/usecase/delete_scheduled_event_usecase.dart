
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/calendar/domain/repostitory/event_schedule_repository.dart';

class DeleteEventScheduleUsecase extends Usecase<void, String> {
  final EventScheduleRepository eventScheduleRepository;

  DeleteEventScheduleUsecase({required this.eventScheduleRepository});

  @override
  Future<Either<Failure, void>> call(String calendarId) async {

    return await eventScheduleRepository.deleteEventSchedule(calendarId);
    
  }

}