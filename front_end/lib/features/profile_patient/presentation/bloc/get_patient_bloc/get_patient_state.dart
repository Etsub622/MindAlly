part of 'get_patient_bloc.dart';


sealed class GetPatientState {
  const GetPatientState();
}

class GetPatientInitial extends GetPatientState {
  const GetPatientInitial();
} 

class GetPatientLoading extends GetPatientState {
  const GetPatientLoading();
}

class GetPatientLoaded extends GetPatientState {
  final PatientEntity patient;
  const GetPatientLoaded({required this.patient});
}

class GetPatientError extends GetPatientState {
  final String message;
  const GetPatientError({required this.message});
}
