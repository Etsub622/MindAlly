

import 'package:equatable/equatable.dart';

class UpdatePatientEntity extends Equatable {
    final String? name;
    final String? email;
    final bool? hasPassword;
    final String? role;
    final String? collage;
    final String? gender;
    final String? preferredModality;
    final String? preferredGender;
    final List<String>? preferredLanguage;
    final List<String>? preferredDays;
    final String? preferredMode;
    final List<String>? preferredSpecialties;
    final String? profilePicture;
  

  const UpdatePatientEntity({
  this.name,
  this.email, 
  this.hasPassword, 
  this.role, 
  this.collage, 
  this.gender, 
  this.preferredModality, 
  this.preferredGender, 
  this.preferredLanguage, 
  this.preferredDays, 
  this.preferredMode, 
  this.profilePicture,
  this.preferredSpecialties
  });

  @override
  List<Object?> get props => [name, email, hasPassword, role, collage];

}