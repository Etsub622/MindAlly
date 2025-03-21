import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/profile_patient/domain/usecases/delete_patient_usecase.dart';


part 'delete_patient_event.dart';
part 'delete_patient_state.dart';





class DeletePatientBloc extends Bloc<DeletePatientEvent, DeletePatientState> {
  final DeletePatientUsecase deletePatientUsecase;

  DeletePatientBloc({required this.deletePatientUsecase}) : super(const DeletePatientInitial()) {
    on<DeletePatientLoadEvent>(_deletePatient);
  }

  void _deletePatient(DeletePatientLoadEvent event, Emitter<DeletePatientState> emit) async {
    emit(const DeletePatientLoading());

    final patient = await deletePatientUsecase(event.patientId);
    
    patient.fold(
      (failure) => emit(DeletePatientError(message: failure.message)),
      (success) => emit(const DeletePatientLoaded()),
    );
  }
}