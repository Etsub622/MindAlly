import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/calendar/data/datasource/event_schedule_local_datasource.dart';
import 'package:front_end/features/calendar/data/datasource/event_schedule_remote_datasource.dart';
import 'package:front_end/features/calendar/data/model/event_model.dart';
import 'package:front_end/features/calendar/domain/entity/event_entity.dart';
import 'package:front_end/features/calendar/domain/repostitory/event_schedule_repository.dart';

class EventScheduleRepositoryImpl extends EventScheduleRepository {
  final EventScheduleRemoteDataSource remoteDataSource;
  final EventScheduleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  EventScheduleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EventEntity>>> getEventSchedules() async {
    // if (await networkInfo.isConnected) {
      try {
        final eventSchedules = await remoteDataSource.getEventSchedules();
        return Right(eventSchedules);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    // } else {
    //   return Left(NetworkFailure(message: "Network is not connected"));
    // }
  }

  @override
  Future<Either<Failure, EventEntity?>> getEventScheduleById(String calendarId) async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, EventEntity>> addEventSchedule(EventEntity eventEntity) async {
    // if (await networkInfo.isConnected) {
      try {
        final event = await remoteDataSource.addEventSchedule(eventEntity as EventModel);
        return Right(event);
      } catch (e) {
        return Left(ServerFailure(message:e.toString()));
      }
    // } else {
    //   return Left(NetworkFailure(message: "Network is not connected"));
    // }
  }

  @override
  Future<Either<Failure, void>> updateEventSchedule(EventEntity eventEntity) async {
    // if (await networkInfo.isConnected) {
      try {
        final event = await remoteDataSource.updateEventSchedule(eventEntity.id);
        return Right(event);
      } catch (e) {
        return Left(ServerFailure(message:e.toString()));
      }
    // } else {
    //   return Left(NetworkFailure(message: "Network is not connected"));
    // }
  }
 

  @override
  Future<Either<Failure, void>> deleteEventSchedule(String calendarId) async {
     // if (await networkInfo.isConnected) {
      try {
        final event = await remoteDataSource.deleteEventSchedule(calendarId);
        return Right(event);
      } catch (e) {
        return Left(ServerFailure(message:e.toString()));
      }
    // } else {
    //   return Left(NetworkFailure(message: "Network is not connected"));
    // }
  }
}