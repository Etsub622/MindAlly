
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/domain/entities/therapist_entity.dart';
import 'package:front_end/features/profile_therapist/domain/usecases/get_therapist_usecase.dart';


part 'get_therapist_event.dart';
part 'get_therapist_state.dart';

class TherapistProfileBloc extends Bloc<GetTherapistEvent, GetTherapistState> {
  final GetTherapistUsecase getTherapistUsecase;

  TherapistProfileBloc({required this.getTherapistUsecase})
      : super(const GetTherapistInitial()) {
    on<GetTherapistLoadEvent>(_getTherapistProfile);
  }

 _getTherapistProfile(
      GetTherapistLoadEvent event, Emitter<GetTherapistState> emit) async {
    emit(const GetTherapistLoading());
    const flutterSecureStorage = FlutterSecureStorage();
    final userData = await flutterSecureStorage.read(key: 'user_profile');
    late TherapistModel? therapist;

    if(userData != null){
      final resData = json.decode(userData);
      therapist = TherapistModel.fromJson(resData);
      emit(GetTherapistLoaded(therapist: therapist));
    }
    
    Either<Failure, TherapistModel> response = await getTherapistUsecase(event.therapistId);
      
    response.fold(
      (failure) {},
      (data) => emit(GetTherapistLoaded(therapist: data)));
  }

}


