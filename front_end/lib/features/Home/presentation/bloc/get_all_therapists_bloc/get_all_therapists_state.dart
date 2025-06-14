part of 'get_all_therapists_bloc.dart';

sealed class GetAllTherapistsState {
  const GetAllTherapistsState();
}

class GetAllTherapistsInitial extends GetAllTherapistsState {}

class GetAllTherapistsLoading extends GetAllTherapistsState {}

class GetAllTherapistsEmpty extends GetAllTherapistsState {}

class GetAllTherapistsLoaded extends GetAllTherapistsState {
  final List<UpdateTherapistEntity> therapistList;

  const GetAllTherapistsLoaded({required this.therapistList});

  @override
  List<Object> get props => [therapistList];
}

class GetAllTherapistsError extends GetAllTherapistsState {
  final String message;

  const GetAllTherapistsError({required this.message});

  @override
  List<Object> get props => [message];
}