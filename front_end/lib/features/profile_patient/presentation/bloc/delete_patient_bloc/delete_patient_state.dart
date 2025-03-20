

part of 'delete_patient_bloc.dart';


sealed class DeletePatientState {
  const DeletePatientState();
}


class DeletePatientInitial extends DeletePatientState {
  const DeletePatientInitial();
}

class DeletePatientLoading extends DeletePatientState {
  const DeletePatientLoading();
}


class DeletePatientLoaded extends DeletePatientState {
  const DeletePatientLoaded();
}

class  DeletePatientError extends DeletePatientState {
  final String message;
  const DeletePatientError({required this.message});
}