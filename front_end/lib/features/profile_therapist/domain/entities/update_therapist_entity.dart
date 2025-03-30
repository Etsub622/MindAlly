import 'package:equatable/equatable.dart';

class UpdateTherapistEntity  extends Equatable{
  final String? chatId;
  final String? id;
  final String? name;
  final String? email;
  final String? modality;
  final String?  certificate;
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

  const UpdateTherapistEntity({
    this.chatId,
    required this.id,
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
  });
  
  @override
  List<Object?> get props => [
    chatId,
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
    experienceYears
  ];
}