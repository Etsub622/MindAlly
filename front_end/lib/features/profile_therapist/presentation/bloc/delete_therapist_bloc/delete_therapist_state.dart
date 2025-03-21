

part of 'delete_therapist_bloc.dart';


sealed class DeleteTherapistState {
  const DeleteTherapistState();
}


class DeleteTherapistInitial extends DeleteTherapistState {
  const DeleteTherapistInitial();
}

class DeleteTherapistLoading extends DeleteTherapistState {
  const DeleteTherapistLoading();
}


class DeleteTherapistLoaded extends DeleteTherapistState {
  const DeleteTherapistLoaded();
}

class  DeleteTherapistError extends DeleteTherapistState {
  final String message;
  const DeleteTherapistError({required this.message});
}