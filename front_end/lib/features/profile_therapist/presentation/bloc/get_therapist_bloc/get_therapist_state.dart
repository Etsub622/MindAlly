part of 'get_therapist_bloc.dart';


sealed class GetTherapistState {
  const GetTherapistState();
}

class GetTherapistInitial extends GetTherapistState {
  const GetTherapistInitial();
} 

class GetTherapistLoading extends GetTherapistState {
  const GetTherapistLoading();
}

class GetTherapistLoaded extends GetTherapistState {
  final TherapistEntity therapist;
  const GetTherapistLoaded({required this.therapist});
}

class GetTherapistError extends GetTherapistState {
  final String message;
  const GetTherapistError({required this.message});
}
