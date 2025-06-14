part of 'get_all_therapists_bloc.dart';

abstract class GetAllTherapistsEvent extends Equatable {
  const GetAllTherapistsEvent();

  @override
  List<Object> get props => [];
}

class GetAllTherapistsLoadEvent extends GetAllTherapistsEvent {}