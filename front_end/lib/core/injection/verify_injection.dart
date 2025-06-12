import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/approve_therapist/data/datasource/therapist_verify_ds.dart';

import 'package:front_end/features/approve_therapist/data/repo_impl/therapist_verify_repo_impl.dart';

import 'package:front_end/features/approve_therapist/domain/repository/therapist_verify_repo.dart';

import 'package:front_end/features/approve_therapist/domain/usecase/therapist_verify_usecase.dart';
import 'package:front_end/features/approve_therapist/presentation/bloc/verify_bloc.dart';

class VerifyInjection {
  void init() {
    // Bloc
    sl.registerFactory(() => VerifyBloc(
          getTherapistsUsecase: sl(),
          verifyUsecase: sl(),
          rejectUsecase: sl(),
        ));

    // Use Cases
    sl.registerLazySingleton(() => GetTherapistsToVerifyUsecase(sl()));
    sl.registerLazySingleton(() => TherapistVerifyUsecase(sl()));
    sl.registerLazySingleton(() => RejectTherapistUsecase(sl()));

    // Repository
    sl.registerLazySingleton<TherapistVerifyRepository>(
        () => TherapistVerifyRepoImpl(sl(), sl()));

    // Data Source
    sl.registerLazySingleton<TherapistVerifyRemoteDatasource>(
        () => TherapistVerifyRemoteDataSourceImpl(sl()));
  }
}
