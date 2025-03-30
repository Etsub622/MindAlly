
import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/Home/data/data_source/home_remote_data_source.dart';
import 'package:front_end/features/Home/data/repository/home_repository_impl.dart';
import 'package:front_end/features/Home/domain/repostitory/home_respository.dart';
import 'package:front_end/features/Home/domain/usecase/get_matched_therpaists_usecase.dart';
import 'package:front_end/features/Home/presentation/bloc/get_matched_therapists_bloc/get_matched_therapists_bloc.dart';

class HomeInjection {
  init() {
    // Use cases
  sl.registerLazySingleton(
      () => GetMatchedTherpaistsUseCase(homeRepository: sl()));
  
  // DataSource
  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl());

  // repository
  sl.registerLazySingleton<HomeRespository>(
    () => HomeRepositoryImpl(
      homeRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Bloc
  sl.registerFactory(() => GetMatchedTherapistsBloc(
      getMatchedTherpaistsUsecase: sl(),
      ));

  }
}
