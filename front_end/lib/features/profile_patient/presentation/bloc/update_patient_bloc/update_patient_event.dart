
part of 'update_patient_bloc.dart';


sealed class UpdatePatientEvent {
  const UpdatePatientEvent();
}

class UpdatePatientLoadEvent extends UpdatePatientEvent {
  final UpdatePatientModel patient;
  const UpdatePatientLoadEvent({required this.patient});
}

