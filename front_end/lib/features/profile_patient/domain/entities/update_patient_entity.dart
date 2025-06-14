

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';

class UpdatePatientEntity extends Equatable {
    final String? name;
    final String? email;
    final bool? hasPassword;
    final String? role;
    final String? collage;
    final String? gender;
    final String? preferredModality;
    final List<String>? preferredGender;
    final List<String>? preferredLanguage;
    final List<String>? preferredDays;
    final List<String>? preferredMode;
    final List<String>? preferredSpecialties;
    final String? profilePicture;
    final PayoutModel? payout;
    final File? profilePictureFile;
  

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
  this.preferredSpecialties,
  this.payout,
  this.profilePictureFile,
  });

  @override
  List<Object?> get props => [name, email, hasPassword, role, collage];

}