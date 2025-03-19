part of 'get_therapist_bloc.dart';


sealed class GetTherapistEvent {
  const GetTherapistEvent();
}

class GetTherapistLoadEvent extends GetTherapistEvent {
  final String therapistId;
  const GetTherapistLoadEvent({required this.therapistId});
}