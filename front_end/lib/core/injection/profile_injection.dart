import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:front_end/features/profile/data/repository_impl/profile_repository_impl.dart';
import 'package:front_end/features/profile/domain/repository/profile_repository.dart';
import 'package:front_end/features/profile/domain/usecases/patient/delete_patient_usecase.dart';
import 'package:front_end/features/profile/domain/usecases/patient/get_patient_usecase.dart';
import 'package:front_end/features/profile/domain/usecases/patient/update_patient_usecase.dart';
import 'package:front_end/features/profile/domain/usecases/therapist/delete_therapist_usecase.dart';
import 'package:front_end/features/profile/domain/usecases/therapist/get_therapist_usecase.dart';
import 'package:front_end/features/profile/domain/usecases/therapist/update_therapist_usecase.dart';
import 'package:front_end/features/profile/presentation/bloc/user_profile_bloc.dart';
import 'package:front_end/features/resource/data/datasource/remote_datasource/Article_remote_datasource.dart';
import 'package:front_end/features/resource/data/repository_impl/article_repo_impl.dart';
import 'package:front_end/features/resource/domain/repository/article_repository.dart';

import 'package:front_end/features/resource/presentation/bloc/article_bloc/bloc/article_bloc.dart';

import '../../features/resource/domain/usecase/article_usecase.dart';

class ProfileInjection {
  init() {
    try {
      // Bloc
      //! Profile ----------------------------------------

//! Bloc
sl.registerFactory(
  () => UserProfileBloc(
    getPatientUsecase: sl(),
    getTherapistUsecase: sl(),
  ),
);

//! Repository
sl.registerLazySingleton<ProfileRepository>(
  () => ProfileRepositoryImpl(
    networkInfo: sl(),
    remoteDatasource: sl(),
  ),
);

//! Data Source
sl.registerLazySingleton<ProfileRemoteDatasource>(
  () => ProfileRemoteDatasourceImpl(client: sl()),
);

//! Usecase
sl.registerLazySingleton(() => GetPatientUsecase(sl()));
sl.registerLazySingleton(() => GetTherapistUsecase(sl()));
sl.registerLazySingleton(() => DeletePatientUsecase(sl()));
sl.registerLazySingleton(() => UpdatePatientUsecase(sl()));
sl.registerLazySingleton(() => UpdateTherapistUsecase(sl()));
sl.registerLazySingleton(() => DeleteTherapistUsecase(sl()));



    } catch (e) {
      print("Error registering dependencies: $e");
    }
  }
}
