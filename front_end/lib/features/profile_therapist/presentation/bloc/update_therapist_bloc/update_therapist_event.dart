
part of 'update_therapist_bloc.dart';



sealed class UpdateTherapistEvent {
  const UpdateTherapistEvent();
}

class UpdateTherapistLoadEvent extends UpdateTherapistEvent {
  final UpdateTherapistModel therapist;
  const UpdateTherapistLoadEvent({required this.therapist});
}


