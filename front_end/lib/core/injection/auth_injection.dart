import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/authentication/data/datasource/auth_local_datasource/login_local_datasource.dart';
import 'package:front_end/features/authentication/data/datasource/auth_remote_datasource/auth_remote_datasource.dart';
import 'package:front_end/features/authentication/data/datasource/reset_password_remote_datasource.dart';
import 'package:front_end/features/authentication/data/repository_impl/auth_repo_impl.dart';
import 'package:front_end/features/authentication/data/repository_impl/reset_password_repo_impl.dart';
import 'package:front_end/features/authentication/data/repository_impl/student_data_repo_impl.dart';
import 'package:front_end/features/authentication/domain/repositories/auth_repo.dart';
import 'package:front_end/features/authentication/domain/repositories/reset_repo.dart';
import 'package:front_end/features/authentication/domain/repositories/student_data_repo.dart';
import 'package:front_end/features/authentication/domain/usecase/Student_user_usecase.dart';
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
        ));

    // Usecase
    sl.registerLazySingleton(() => LoginUsecase(sl()));
    sl.registerLazySingleton(() => ProfessionalSignupUsecase(sl()));
    sl.registerLazySingleton(() => StudentSignupUsecase(sl()));
    sl.registerLazySingleton(() => SendOtpUseCase(sl()));
    sl.registerLazySingleton(() => verifyOtpUsecase(sl()));
    sl.registerLazySingleton(() => ResetpasswordUsecase(sl()));
    sl.registerLazySingleton(() => StudentUserUsecase(sl()));

    // Repository
    sl.registerLazySingleton<AuthRepository>(
        () => AuthRepoImpl(sl(), sl(), sl()));

    sl.registerLazySingleton<ResetPasswordRepo>(
        () => ResetPasswordRepoImpl(sl(), sl()));
    sl.registerLazySingleton<StudentDataRepo>(
        () => GetStudentDataRepoImpl(sl(), sl(), sl()));

    // Data Source
    sl.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasourceImpl(client: sl()));
    sl.registerLazySingleton<LoginLocalDataSource>(
        () => LoginLocalDataSourceImpl(sharedPreferences: sl()));

    sl.registerLazySingleton<ResetPasswordRemoteDatasource>(
        () => ResetPasswordRemoteImpl(sl()));
  }
}
