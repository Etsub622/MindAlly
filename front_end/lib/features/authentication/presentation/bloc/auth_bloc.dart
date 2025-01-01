import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:front_end/features/authentication/domain/entities/login_entity.dart';
import 'package:front_end/features/authentication/domain/entities/professional_signup_entity.dart';
import 'package:front_end/features/authentication/domain/entities/reset_password.dart';
import 'package:front_end/features/authentication/domain/entities/student_data.dart';
import 'package:front_end/features/authentication/domain/entities/student_signup_entity.dart';
import 'package:front_end/features/authentication/domain/usecase/Student_user_usecase.dart';
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
  AuthBloc({
    required this.professionalUsecase,
    required this.studentUsecase,
    required this.loginUsecase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUsecase,
    required this.studentUserUsecase,
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
        (success) => emit(AuthSuccess(success as String)),
      );
    });

    on<sendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await sendOtpUseCase(sendOtpParams(event.phoneNumber));
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(AuthOtpSent(success)),
      );
    });

    on<verifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      final result =
          await verifyOtpUseCase(verifyOtpParams(event.otp, event.phoneNumber));
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(AuthOtpVerified(success)),
      );
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      final result =
          await resetPasswordUsecase(ResetParams(event.resetPasswordEntity));
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (success) => emit(AuthSuccess(success as String)),
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
