
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
    super.chatId,
    });

    factory UpdateTherapistModel.fromJson(Map<String, dynamic> json) {
    return UpdateTherapistModel(
      id: json['_id'],
      name: json['FullName'],
      email: json['Email'],
      chatId: json['chatId'],
      modality: json['modality'],
      certificate: json['Certificate'],
      bio: json['bio'] ?? "",
      fee: json['fee'] ?? 0,
      rating: json['rating'] ?? 0.0,
      gender: json['gender'],
      verified: json['verified'] ?? false,
      specialities: json['specialities'] != null
            ? (json['specialities'] as List<dynamic>).map((e) => e.toString()).toList()
            : null,
      availableDays: json['available_days'] != null
            ? (json['available_days'] as List<dynamic>).map((e) => e.toString()).toList()
            : null,
      profilePicture: json['profilePicture'] ?? "",
      language: json['language'] != null
            ? (json['language'] as List<dynamic>).map((e) => e.toString()).toList()
            : null,
      mode: json['mode'] != null
            ? (json['mode'] as List<dynamic>).map((e) => e.toString()).toList()
            : null,
      experienceYears:json['experience_years'] ?? 0,
    );
    }

    Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'FullName': name,
      'Email': email,
      'modality': modality,
      'Certificate': certificate,
      'Bio': bio,
      'fee': fee,
      'rating': rating,
      'gender': gender,
      'verified': verified,
      'specialities': specialities,
      'available_days': availableDays,
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