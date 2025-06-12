import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/calendar/data/datasource/event_schedule_local_datasource.dart';
import 'package:front_end/features/calendar/data/datasource/event_schedule_remote_datasource.dart';
import 'package:front_end/features/calendar/data/repository/event_schedule_repository_impl.dart';
import 'package:front_end/features/calendar/domain/repostitory/event_schedule_repository.dart';
import 'package:front_end/features/calendar/domain/usecase/add_event_schedule_usecase.dart';
import 'package:front_end/features/calendar/domain/usecase/delete_scheduled_event_usecase.dart';
import 'package:front_end/features/calendar/domain/usecase/get_scheduled_event_usecase.dart';
import 'package:front_end/features/calendar/domain/usecase/get_single_scheduled_event_usecase.dart';
import 'package:front_end/features/calendar/domain/usecase/update_scheduled_event_usecase.dart';
import 'package:front_end/features/calendar/presentation/bloc/add_event/add_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/delete_event/delete_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_events/get_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_single_event/get_event_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/update_event/update_events_bloc.dart';

class CalendarInjection {
  init() {
    // Use cases
  sl.registerLazySingleton(
      () => AddEventScheduleUsecase(eventScheduleRepository: sl()));
  sl.registerLazySingleton(
      () => DeleteEventScheduleUsecase(eventScheduleRepository: sl()));
  sl.registerLazySingleton(
      () => GetEventScheduleUsecase(eventScheduleRepository: sl()));
  
  sl.registerLazySingleton(
      () => GetSingleEventScheduleUsecase(eventScheduleRepository: sl()));

  sl.registerLazySingleton(
      () => UpdateScheduledEventUsecase(eventScheduleRepository: sl()));


  // DataSource
  sl.registerLazySingleton<EventScheduleRemoteDataSource>(
      () => EventScheduleRemoteDataSourceImpl(
        client: sl(),
      ));
  
  sl.registerLazySingleton<EventScheduleLocalDataSource>(
      () => EventScheduleLocalDataSourceImpl());

  // repository
  sl.registerLazySingleton<EventScheduleRepository>(
    () => EventScheduleRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Bloc
  sl.registerFactory(() => AddScheduledEventsBloc(
      addScheduledEventsUsecase: sl()));

  sl.registerFactory(() => DeleteScheduledEventsBloc(
      deleteScheduledEventsUsecase: sl()));
  sl.registerFactory(() => GetScheduledEventsBloc(getScheduledEventsUsecase: sl<GetEventScheduleUsecase>()));

  sl.registerFactory(() => GetScheduledEventBloc(
      getSingleScheduledEventUsecase: sl()));


  sl.registerFactory(() => UpdateScheduledEventsBloc(
      updateScheduledEventsUsecase: sl(),));

  }
}