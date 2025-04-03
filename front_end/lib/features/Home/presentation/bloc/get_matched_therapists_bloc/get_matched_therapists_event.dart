part of 'get_matched_therapists_bloc.dart';

sealed class GetMatchedTherapistsEvent {
  const GetMatchedTherapistsEvent();
}


class GetMatchedTherapistsLoadEvent extends GetMatchedTherapistsEvent {
  final String patientId;
  const GetMatchedTherapistsLoadEvent({required this.patientId});
}
