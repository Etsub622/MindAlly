

part of 'update_therapist_bloc.dart';


sealed class UpdateTherapistState {
  const UpdateTherapistState();
}


class UpdateTherapistInitial extends UpdateTherapistState {
  const UpdateTherapistInitial();
}

class UpdateTherapistLoading extends UpdateTherapistState {
  const UpdateTherapistLoading();
}


class UpdateTherapistLoaded extends UpdateTherapistState {
  final UpdateTherapistEntity therapist;
  const UpdateTherapistLoaded({required this.therapist});
}

class  UpdateTherapistError extends UpdateTherapistState {
  final String message;
  const UpdateTherapistError({required this.message});
}