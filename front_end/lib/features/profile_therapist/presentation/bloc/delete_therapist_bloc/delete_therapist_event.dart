
part of 'delete_therapist_bloc.dart';



sealed class DeleteTherapistEvent {
  const DeleteTherapistEvent();
}

class DeleteTherapistLoadEvent extends DeleteTherapistEvent {
  final String therapistId;
  const DeleteTherapistLoadEvent({required this.therapistId});
}


