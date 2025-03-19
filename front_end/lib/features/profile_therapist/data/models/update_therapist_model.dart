
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';

class UpdateTherapistModel  extends UpdateTherapistEntity{
  const UpdateTherapistModel({
    super.id,
    super.name,
    super.email,
    super.modality,
    super.certificate,
    super.bio,
    super.fee,
    super.rating,
    super.gender,
    super.verified,
    super.specialities,
    super.availableDays,
    super.profilePicture,
    super.language,
    super.mode,
    super.experienceYears,
    });

    factory UpdateTherapistModel.fromJson(Map<String, dynamic> json) {
    return UpdateTherapistModel(
      id: json['_id'],
      name: json['FullName'],
      email: json['Email'],
      modality: json['modality'],
      certificate: json['Certificate'],
      bio: json['bio'] ?? "",
      fee: json['fee'] ?? 0,
      rating: json['rating'] ?? 0.0,
      gender: json['gender'],
      verified: json['verified'] ?? false,
      specialities: json['specialities'] ?? List<String>.from(json['specialities'] ?? []),
      availableDays: json['availableDays'] ?? List<String>.from(json['availableDays'] ?? []),
      profilePicture: json['profilePicture'] ?? "",
      language: json['language'] ?? List<String>.from(json['language'] ?? []),
      mode: json['mode'] ?? List<String>.from(json['mode'] ?? []),
      experienceYears:json['experience_years'] ?? 0,
    );
    }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'modality': modality,
      'certificate': certificate,
      'bio': bio,
      'fee': fee,
      'rating': rating,
      'gender': gender,
      'verified': verified,
      'specialities': specialities,
      'availableDays': availableDays,
      'profilePicture': profilePicture,
      'language': language,
      'mode': mode,
      'experience_years': experienceYears,
    };
    }

    UpdateTherapistModel copyWith({
    String? id,
    String? name,
    String? email,
    String? modality,
    String? certificate,
    String? bio,
    double? fee,
    double? rating,
    String? gender,
    bool? verified,
    List<String>? specialities,
    List<String>? availableDays,
    String? profilePicture,
    List<String>? language,
    List<String>? mode,
    int? experienceYears,
    }) {
    return UpdateTherapistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      modality: modality ?? this.modality,
      certificate: certificate ?? this.certificate,
      bio: bio ?? this.bio,
      fee: fee ?? this.fee,
      rating: rating ?? this.rating,
      gender: gender ?? this.gender,
      verified: verified ?? this.verified,
      specialities: specialities ?? this.specialities,
      availableDays: availableDays ?? this.availableDays,
      profilePicture: profilePicture ?? this.profilePicture,
      language: language ?? this.language,
      mode: mode ?? this.mode,
      experienceYears: experienceYears ?? this.experienceYears,
    );
    }
  
}