
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';

abstract class EventScheduleRepository {
  Future<Either<Failure, List<EventEntity>>> getEventSchedules();
  Future<Either<Failure, EventEntity?>> getEventScheduleById(String id);
  
  Future<Either<Failure, void>> addEventSchedule(EventEntity eventEntity);

  Future<Either<Failure, void>> updateEventSchedule(EventEntity eventEntity);
  Future<Either<Failure, void>> deleteEventSchedule(String id);
}