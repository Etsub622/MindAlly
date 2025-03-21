import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/profile_patient/data/datasource/patient_profile_remote_datasource.dart';
import 'package:front_end/features/profile_patient/data/datasource/profile_local_datasource.dart';
import 'package:front_end/features/profile_patient/data/repository_impl/patient_profile_repository_impl.dart';
import 'package:front_end/features/profile_patient/domain/repository/patient_profile_repository.dart';
import 'package:front_end/features/profile_patient/domain/usecases/delete_patient_usecase.dart';
import 'package:front_end/features/profile_patient/domain/usecases/get_patient_usecase.dart';
import 'package:front_end/features/profile_patient/domain/usecases/update_patient_usecase.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/update_patient_bloc/update_patient_bloc.dart';
import 'package:front_end/features/profile_therapist/data/datasource/therapist_profile_remote_datasource.dart';
import 'package:front_end/features/profile_therapist/data/repository_impl/therapist_profile_repository_impl.dart';
import 'package:front_end/features/profile_therapist/domain/repository/therapist_profile_repository.dart';
import 'package:front_end/features/profile_therapist/domain/usecases/delete_therapist_usecase.dart';
import 'package:front_end/features/profile_therapist/domain/usecases/get_therapist_usecase.dart';
import 'package:front_end/features/profile_therapist/domain/usecases/update_therapist_usecase.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/update_therapist_bloc/update_therapist_bloc.dart';


class ProfileInjection {
  void init() {
    try {
      // Data Source
      sl.registerLazySingleton<TherapistProfileRemoteDatasource>(
        () => TherapistProfileRemoteDatasourceImpl(client: sl()),
      );

      sl.registerLazySingleton<PatientProfileRemoteDatasource>(
        () => PatientProfileRemoteDatasourceImpl(client: sl()),
      );

      sl.registerLazySingleton<ProfileLocalDataSource>(
        () => ProfileLocalDataSourceImpl(
          flutterSecureStorage: sl(),
        ),
      );

      // Repository
      sl.registerLazySingleton<PatientProfileRepository>(
        () => PatientProfileRepositoryImpl(
          networkInfo: sl(),
          remoteDatasource: sl(),
          localDatasource: sl(),
        ),
      );
      sl.registerLazySingleton<TherapistProfileRepository>(
        () => TherapistProfileRepositoryImpl(
          networkInfo: sl(),
          remoteDatasource: sl(),
          localDatasource: sl(),
        ),
      );

      // Usecase
      sl.registerLazySingleton(() => GetPatientUsecase(sl()));
      sl.registerLazySingleton(() => DeletePatientUsecase(sl()));
      sl.registerLazySingleton(() => UpdatePatientUsecase(sl()));
      sl.registerLazySingleton(() => GetTherapistUsecase(sl()));
      sl.registerLazySingleton(() => UpdateTherapistUsecase(sl()));
      sl.registerLazySingleton(() => DeleteTherapistUsecase(sl()));

      // Bloc
      sl.registerFactory(
        () => PatientProfileBloc(
          getPatientUsecase: sl(),
        ),
      );
     
      sl.registerFactory(
        () => UpdatePatientBloc(
          updatePatientUsecase: sl(),
        ),
      );
      sl.registerFactory(
        () => TherapistProfileBloc(
          getTherapistUsecase: sl(),
        ),
      );
      sl.registerFactory(
        () => UpdateTherapistBloc(
          updateTherapistUsecase: sl(),
        ),
      );
    } catch (e) {
      print("Error registering dependencies: $e");
    }
  }
}