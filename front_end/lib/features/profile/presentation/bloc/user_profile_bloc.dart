
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:front_end/features/profile/data/models/patient_model.dart';
import 'package:front_end/features/profile/data/models/therapist_model.dart';
import 'package:front_end/features/profile/domain/usecases/patient/get_patient_usecase.dart';
import 'package:front_end/features/profile/domain/usecases/therapist/get_therapist_usecase.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserprofileEvent, UserprofileState> {
  final GetPatientUsecase getPatientUsecase;
  final GetTherapistUsecase getTherapistUsecase;

  UserProfileBloc({required this.getPatientUsecase, required this.getTherapistUsecase})
      : super(UserprofileInitial()) {
    on<GetPatientProfileEvent>(_getPatientProfile);
    on<GetTherapistProfileEvent>(_getTherapistProfile);
     on<GetUserProfileEvent>(_getProfile);
    // on<CheckUserProfileEvent>(_checkProfile);

  }

   _getPatientProfile(
      GetPatientProfileEvent event, Emitter<UserprofileState> emit) async {
    emit(const PatientProfileLoadedState(
      status: UserStatus.loading,
      patientProfile: null
    ));

    Either<Failure, PatientModel> response = await getPatientUsecase(event.id);
      
    response.fold(
      (failure) => emit(const PatientProfileLoadedState(
        status: UserStatus.error,
        patientProfile: null)), 
      (data) => emit(PatientProfileLoadedState(
        status: UserStatus.loaded,
        patientProfile: data
      )));
  }


 _getTherapistProfile(
      GetTherapistProfileEvent event, Emitter<UserprofileState> emit) async {
    emit(const TherapistProfileLoadedState(
      status: UserStatus.loading,
      therapistProfile: null
    ));

    Either<Failure, TherapistModel> response = await getTherapistUsecase(event.id);
      
    response.fold(
      (failure) => emit(const TherapistProfileLoadedState(
        status:UserStatus.error,
        therapistProfile: null )), 
      (data) => emit(TherapistProfileLoadedState(
        status: UserStatus.loaded,
        therapistProfile: data
      )));
  }

 final FlutterSecureStorage flutterSecureStorage =
      const FlutterSecureStorage();

  final String authenticationKey = "access_token";
  final String userProfileKey = "user_profile";
  
  Future<StudentDataModel> getUserCredential() async {
    final userCredential = await flutterSecureStorage.read(key: userProfileKey);

    if (userCredential != null) {
      final body = await json.decode(userCredential);

      final res = StudentDataModel.fromJson(body);

      return res;
    } else {
      throw CacheException(message: 'User profile not found');
    }
  }

  void _getProfile(
      UserprofileEvent event, Emitter<UserprofileState> emit) async {
    emit(UserprofileInitial());

    final response = await getUserCredential();

    emit(UserprofileLoadedState(userEntity: response, status: UserStatus.loaded));
  }

}


