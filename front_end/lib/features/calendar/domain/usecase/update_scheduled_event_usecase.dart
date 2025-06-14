
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/domain/repostitory/event_schedule_repository.dart';

class UpdateScheduledEventUsecase extends Usecase<void, EventEntity> {
  final EventScheduleRepository eventScheduleRepository;

  UpdateScheduledEventUsecase({required this.eventScheduleRepository});

  @override
  Future<Either<Failure, void>> call(EventEntity eventEntity) async {
    return await eventScheduleRepository.updateEventSchedule(eventEntity);
  }

}