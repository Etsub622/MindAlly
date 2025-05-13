
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/domain/repostitory/event_schedule_repository.dart';

class GetSingleEventScheduleUsecase extends Usecase<EventEntity?, String> {
  final EventScheduleRepository eventScheduleRepository;

  GetSingleEventScheduleUsecase({required this.eventScheduleRepository});

  @override
  Future<Either<Failure, EventEntity?>> call(String id) async {

    return await eventScheduleRepository.getEventScheduleById(id);
    
  }

}