import 'package:front_end/core/injection/injections.dart';
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

class AuthInjection {
  init() {
    // Bloc
    sl.registerFactory(() => AuthBloc(
          professionalUsecase: sl(),
          studentUsecase: sl(),
          loginUsecase: sl(),
          sendOtpUseCase: sl(),
          verifyOtpUseCase: sl(),
          resetPasswordUsecase: sl(),
          studentUserUsecase: sl(),
          logOutUsecase: sl(),
        ));

    // Usecase
    sl.registerLazySingleton(() => LoginUsecase(authRepository: sl()));
    sl.registerLazySingleton(
        () => ProfessionalSignupUsecase(authRepository: sl()));
    sl.registerLazySingleton(() => StudentSignupUsecase(authRepository: sl()));
    sl.registerLazySingleton(() => SendOtpUseCase(authRepository: sl()));
    sl.registerLazySingleton(() => verifyOtpUsecase(authRepository: sl()));
    sl.registerLazySingleton(
        () => ResetpasswordUsecase(resetPasswordRepo: sl()));
    sl.registerLazySingleton(() => StudentUserUsecase(studentDataRepo: sl()));
    sl.registerLazySingleton(() => LogOutUsecase(sl()));

    // Repository
    sl.registerLazySingleton<AuthRepository>(() => AuthRepoImpl(
        loginLocalDataSource: sl(),
        networkInfo: sl(),
        authRemoteDatasource: sl()));
    sl.registerLazySingleton<LogOutRepo>(() => LogOutRepoImpl(
        loginLocalDataSource: sl(),
        networkInfo: sl(),
        authRemoteDatasource: sl()));
    sl.registerLazySingleton<ResetPasswordRepo>(() => ResetPasswordRepoImpl(
        resetPasswordRemoteDatasource: sl(), networkInfo: sl()));
    sl.registerLazySingleton<StudentDataRepo>(() => GetStudentDataRepoImpl(
        loginLocalDataSource: sl(),
        networkInfo: sl(),
        authRemoteDatasource: sl()));

    // Data Source
    sl.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(client: sl()));
    sl.registerLazySingleton<LoginLocalDataSource>(
        () => LoginLocalDataSourceImpl(sharedPreferences: sl(), flutterSecureStorage: sl()));

    sl.registerLazySingleton<ResetPasswordRemoteDatasource>(
        () => ResetPasswordRemoteImpl(sl()));
  }
}
