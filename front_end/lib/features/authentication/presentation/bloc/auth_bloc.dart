import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:front_end/features/authentication/domain/entities/login_entity.dart';
import 'package:front_end/features/authentication/domain/entities/professional_signup_entity.dart';
import 'package:front_end/features/authentication/domain/entities/reset_password.dart';
import 'package:front_end/features/authentication/domain/entities/student_data.dart';
import 'package:front_end/features/authentication/domain/entities/student_signup_entity.dart';
import 'package:front_end/features/authentication/domain/usecase/Student_user_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/log_out_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/login_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/otp_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/professional_signup_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/resetPassword_usecase.dart';
import 'package:front_end/features/authentication/domain/usecase/student_signup_usecase.dart';
import 'package:front_end/features/authentication/presentation/screens/reset_password.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ProfessionalSignupUsecase professionalUsecase;
  final StudentSignupUsecase studentUsecase;
  final LoginUsecase loginUsecase;
  final SendOtpUseCase sendOtpUseCase;
  final verifyOtpUsecase verifyOtpUseCase;
  final ResetpasswordUsecase resetPasswordUsecase;
  final StudentUserUsecase studentUserUsecase;
  final LogOutUsecase logOutUsecase;
  AuthBloc({
    required this.professionalUsecase,
    required this.studentUsecase,
    required this.loginUsecase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUsecase,
    required this.studentUserUsecase,
    required this.logOutUsecase,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ProfessionalsignUpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await professionalUsecase(
          ProfessionalSignUpParams(event.professionalSignupEntity));
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(AuthSuccess(success)),
      );
    });

    on<StudentsignUpEvent>((event, emit) async {
      emit(AuthLoading());
      final result =
          await studentUsecase(SignUpParams(event.studentSignupEntity));
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(AuthSuccess(success)),
      );
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUsecase(LogInParams(event.loginEntity));
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(LoginSuccess(success)),
      );
    });

    on<LogoutEvent>(
      (event, emit) async {
        emit(AuthLoading());
        final result = await logOutUsecase(NoParams());
        result.fold(
          (failure) => emit(UserLogoutState(
              message: "Failed to logout, please try again",
              status: AuthStatus.error)),
          (response) => emit(UserLogoutState(
              message: "Logged out successfully", status: AuthStatus.loaded)),
        );
      },
    );

    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await sendOtpUseCase(sendOtpParams(event.email));
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(AuthOtpSent(success)),
      );
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result =
          await verifyOtpUseCase(verifyOtpParams(event.otp, event.email));
      result.fold(
        (failure) => emit(AuthOtpVerifyError(failure.message)),
        (success) => emit(AuthOtpVerified(success)),
      );
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final result =
          await resetPasswordUsecase(ResetParams(event.resetPasswordEntity));
      result.fold(
        (failure) => emit(ResetPasswordError(failure.message)),
        (success) => emit(ResetPasswordSuccess(success)),
      );
    });

    on<StudentDataEvent>((event, emit) async {
      try {
        final studentDataModel = await studentUserUsecase(StudentParams());

        studentDataModel.fold(
          (failure) => emit(AuthError(failure.message)),
          (success) => emit(StudentDataLoaded(success)),
        );
      } catch (e) {
        emit(AuthError('Error'));
      }
    });
  }
}
