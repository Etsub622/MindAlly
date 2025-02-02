import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/core/routes/router_config.dart';
import 'package:front_end/features/authentication/data/datasource/auth_local_datasource/login_local_datasource.dart';
import 'package:front_end/features/authentication/data/datasource/auth_remote_datasource/auth_remote_datasource.dart';
import 'package:front_end/features/authentication/data/datasource/reset_password_remote_datasource.dart';
import 'package:front_end/features/authentication/data/repository_impl/auth_repo_impl.dart';
import 'package:front_end/features/authentication/data/repository_impl/log_out_repo_impl.dart';
import 'package:front_end/features/authentication/data/repository_impl/reset_password_repo_impl.dart';
import 'package:front_end/features/authentication/data/repository_impl/student_data_repo_impl.dart';
import 'package:front_end/features/authentication/domain/repositories/auth_repo.dart';
import 'package:front_end/features/authentication/domain/repositories/log_out_repo.dart';
import 'package:front_end/features/authentication/domain/repositories/reset_repo.dart';
import 'package:front_end/features/authentication/domain/repositories/student_data_repo.dart';
import 'package:front_end/features/authentication/domain/usecase/Student_user_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/log_out_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/login_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/otp_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/professional_signup_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/resetPassword_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/student_signup_usecase.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
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
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator.registerSingleton<GoRouter>(routerConfig());

  //! Feature_#1 Authentication ----------------------------------------

//! Bloc
  serviceLocator.registerFactory(
    () => AuthBloc(
      professionalUsecase: serviceLocator(),
      studentUsecase: serviceLocator(),
      loginUsecase: serviceLocator(),
      sendOtpUseCase: serviceLocator(),
      verifyOtpUseCase: serviceLocator(),
      resetPasswordUsecase: serviceLocator(),
      studentUserUsecase: serviceLocator(),
      logOutUsecase: serviceLocator(),
    ),
  );

//! Repository

  serviceLocator.registerLazySingleton<StudentDataRepo>(() =>
      GetStudentDataRepoImpl(
          loginLocalDataSource: serviceLocator(),
          networkInfo: serviceLocator(),
          authRemoteDatasource: serviceLocator()));

  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepoImpl(
      loginLocalDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
      authRemoteDatasource: serviceLocator()));

  serviceLocator.registerLazySingleton<ResetPasswordRepo>(() =>
      ResetPasswordRepoImpl(
          resetPasswordRemoteDatasource: serviceLocator(),
          networkInfo: serviceLocator()));

  serviceLocator.registerLazySingleton<LogOutRepo>(() => LogOutRepoImpl(
      loginLocalDataSource: serviceLocator(),
      authRemoteDatasource: serviceLocator(),
      networkInfo: serviceLocator()));

//! Data Source
  serviceLocator.registerLazySingleton<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(client: serviceLocator()));
  serviceLocator.registerLazySingleton<LoginLocalDataSource>(
      () => LoginLocalDataSourceImpl(sharedPreferences: serviceLocator(), flutterSecureStorage: serviceLocator()));
  serviceLocator.registerLazySingleton<ResetPasswordRemoteDatasource>(
      () => ResetPasswordRemoteImpl(serviceLocator()));

  //! Usecase
  serviceLocator.registerLazySingleton(
      () => LoginUsecase(authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => verifyOtpUsecase(authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => SendOtpUseCase(authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => ProfessionalSignupUsecase(authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => ResetpasswordUsecase(resetPasswordRepo: serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => StudentSignupUsecase(authRepository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => StudentUserUsecase(studentDataRepo: serviceLocator()));
  serviceLocator.registerLazySingleton(() => LogOutUsecase(serviceLocator()));
     

     //! Profile ----------------------------------------

//! Bloc
  serviceLocator.registerFactory(
    () => UserProfileBloc(
      getPatientUsecase: serviceLocator(),
      getTherapistUsecase: serviceLocator(),
    ),
  );

//! Repository
serviceLocator.registerLazySingleton<ProfileRepository>(() =>
      ProfileRepositoryImpl(
          networkInfo: serviceLocator(),
          remoteDatasource: serviceLocator()));

//! Data Source
  serviceLocator.registerLazySingleton<ProfileRemoteDatasource>(
      () => ProfileRemoteDatasourceImpl(client: serviceLocator()));

  //! Usecase
  serviceLocator.registerLazySingleton(
      () => GetPatientUsecase(serviceLocator()));

  serviceLocator.registerLazySingleton(
      () => GetTherapistUsecase(serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => DeletePatientUsecase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => UpdatePatientUsecase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateTherapistUsecase(serviceLocator()));
    serviceLocator.registerLazySingleton(
    () => DeleteTherapistUsecase(serviceLocator()),
  );

  
  //! External-----------------------------------

  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerFactory(() => prefs);
  serviceLocator.registerLazySingleton(() => const FlutterSecureStorage());

  serviceLocator.registerLazySingleton<http.Client>(() => http.Client());
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));
  serviceLocator.registerLazySingleton(() => InternetConnection());
}
