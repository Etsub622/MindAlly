
part of 'user_profile_bloc.dart';

enum UserStatus {loading, loaded, error }

abstract class UserprofileState extends Equatable {
  const UserprofileState();

  @override
  List<Object?> get props => [];
}

final class UserprofileInitial extends UserprofileState {}

class UserprofileLoadedState extends UserprofileState {
  final StudentDataModel? userEntity;
  final UserStatus status;

  const UserprofileLoadedState({
    this.userEntity,
    this.status = UserStatus.loading,
  });

  @override
  List<Object?> get props => [userEntity];
}
class PatientProfileLoadedState extends UserprofileState {
  final PatientModel? patientProfile;
  final UserStatus status;

  const PatientProfileLoadedState({
    this.patientProfile,
    this.status = UserStatus.loading,
  });
  
  @override
  List<Object?> get props => [patientProfile];
}

class TherapistProfileLoadedState extends UserprofileState {
  final TherapistModel? therapistProfile;
  final UserStatus status;
  
  const TherapistProfileLoadedState({
    this.therapistProfile,
    this.status = UserStatus.loading,
  });

  @override
  List<Object?> get props => [therapistProfile];
}

