
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/profile_patient/data/models/patient_model.dart';
import 'package:front_end/features/profile_patient/domain/entities/patient_entity.dart';
import 'package:front_end/features/profile_patient/domain/usecases/get_patient_usecase.dart';

part 'get_patient_event.dart';
part 'get_patient_state.dart';

class PatientProfileBloc extends Bloc<GetPatientEvent, GetPatientState> {
  final GetPatientUsecase getPatientUsecase;

  PatientProfileBloc({required this.getPatientUsecase})
      : super(const GetPatientInitial()) {
    on<GetPatientLoadEvent>(_getPatientProfile);
  }

   _getPatientProfile(
      GetPatientLoadEvent event, Emitter<GetPatientState> emit) async {
    emit(const GetPatientLoading());

    Either<Failure, PatientModel> response = await getPatientUsecase(event.patientId);
    
    response.fold(
      (failure) => emit(GetPatientError(message: failure.message)), 
      (data) => emit(GetPatientLoaded(patient: data)));
  }
}