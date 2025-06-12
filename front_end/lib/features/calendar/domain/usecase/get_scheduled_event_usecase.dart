
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/domain/repostitory/event_schedule_repository.dart';

class GetEventScheduleUsecase extends Usecase<List<EventEntity>, NoParams> {
  final EventScheduleRepository eventScheduleRepository;

  GetEventScheduleUsecase({required this.eventScheduleRepository});

  @override
  Future<Either<Failure, List<EventEntity>>> call(noParams) async {

    return await eventScheduleRepository.getEventSchedules();
    
  }

}