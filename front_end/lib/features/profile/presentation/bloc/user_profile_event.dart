part of 'user_profile_bloc.dart';

sealed class UserprofileEvent {}


final class GetPatientProfileEvent extends UserprofileEvent {
  final String id;

  GetPatientProfileEvent({required this.id});
}


final class GetTherapistProfileEvent extends UserprofileEvent {
  final String id;

  GetTherapistProfileEvent({required this.id});
}


final class GetUserProfileEvent extends UserprofileEvent {}
final class CheckUserProfileEvent extends UserprofileEvent {}
