import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/profile_patient/data/models/update_patient_model.dart';
import 'package:front_end/features/profile_patient/domain/entities/update_patient_entity.dart';
import 'package:front_end/features/profile_patient/domain/usecases/update_patient_usecase.dart';


part 'update_patient_event.dart';
part 'update_patient_state.dart';




class UpdatePatientBloc extends Bloc<UpdatePatientEvent, UpdatePatientState> {
  final UpdatePatientUsecase updatePatientUsecase;
  UpdatePatientBloc({required this.updatePatientUsecase}) : super(const UpdatePatientInitial()) {
    on<UpdatePatientLoadEvent>(_updatePatient);
  }

  void _updatePatient(UpdatePatientLoadEvent event, Emitter<UpdatePatientState> emit) async {
    emit(const UpdatePatientLoading());

    final patient = await updatePatientUsecase(event.patient);
    
    patient.fold(
      (failure) => emit(UpdatePatientError(message: failure.message)),
      (patient) => emit(UpdatePatientLoaded(patient: patient)),
    );
  }
}