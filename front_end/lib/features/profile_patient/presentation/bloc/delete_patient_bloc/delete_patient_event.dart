
part of 'delete_patient_bloc.dart';



sealed class DeletePatientEvent {
  const DeletePatientEvent();
}

class DeletePatientLoadEvent extends DeletePatientEvent {
  final String patientId;
  const DeletePatientLoadEvent({required this.patientId});
}


