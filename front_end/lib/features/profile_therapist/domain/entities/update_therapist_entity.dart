import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';

class UpdateTherapistEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? modality;
  final String? certificate;
  final String? bio;
  final double? fee;
  final double? rating;
  final String? gender;
  final bool? verified;
  final List<String>? specialities;
  final List<String>? availableDays;
  final List<String>? language;
  final List<String>? mode;
  final String? profilePicture;
  final int? experienceYears;
  final String? chatId;
  final PayoutModel? payout;
  final File? profilePictureFile;

  const UpdateTherapistEntity(
      {required this.id,
      this.name,
      this.email,
      this.modality,
      this.certificate,
      this.bio,
      this.fee,
      this.rating,
      this.gender,
      this.verified,
      this.specialities,
      this.availableDays,
      this.language,
      this.mode,
      this.profilePicture,
      this.experienceYears,
      this.chatId,
      this.payout,
      this.profilePictureFile,
      });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        modality,
        certificate,
        bio,
        fee,
        rating,
        gender,
        verified,
        specialities,
        availableDays,
        language,
        mode,
        experienceYears,
        chatId,
      ];
}
