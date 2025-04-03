

part of 'update_patient_bloc.dart';


sealed class UpdatePatientState {
  const UpdatePatientState();
}


class UpdatePatientInitial extends UpdatePatientState {
  const UpdatePatientInitial();
}

class UpdatePatientLoading extends UpdatePatientState {
  const UpdatePatientLoading();
}


class UpdatePatientLoaded extends UpdatePatientState {
  final UpdatePatientEntity patient;
  const UpdatePatientLoaded({required this.patient});
}

class  UpdatePatientError extends UpdatePatientState {
  final String message;
  const UpdatePatientError({required this.message});
}