part of 'get_matched_therapists_bloc.dart';

sealed class GetMatchedTherapistsState {
  const GetMatchedTherapistsState();
} 


class GetMatchedTherapistsInitial extends GetMatchedTherapistsState {
  const GetMatchedTherapistsInitial();
}

class GetMatchedTherapistsLoading extends GetMatchedTherapistsState {
  const GetMatchedTherapistsLoading();
}

class GetMatchedTherapistsLoaded extends GetMatchedTherapistsState {
  final List<UpdateTherapistModel> therapistList;
  const GetMatchedTherapistsLoaded({required this.therapistList});
}

class GetMatchedTherapistsError extends GetMatchedTherapistsState {
  final String message;
  const GetMatchedTherapistsError({required this.message});
}

class GetMatchedTherapistsEmpty extends GetMatchedTherapistsState {
  const GetMatchedTherapistsEmpty();
}