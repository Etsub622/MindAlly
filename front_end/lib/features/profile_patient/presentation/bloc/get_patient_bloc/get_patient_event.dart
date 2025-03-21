part of 'get_patient_bloc.dart';

sealed class GetPatientEvent {
  const GetPatientEvent();
}

class GetPatientLoadEvent extends GetPatientEvent {
  final String patientId;
  const GetPatientLoadEvent({required this.patientId});
}