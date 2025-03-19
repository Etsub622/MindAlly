

import 'package:front_end/features/profile_therapist/domain/entities/therapist_entity.dart';

class   TherapistModel extends TherapistEntity {

  const TherapistModel({
    required  super.id,
    required  super.name,
    required  super.email,
    required  super.hasPassword,
    required  super.role,
    required super.bio,
    required super.certificate,
    required super.fee,
    required super.rating,
    required super.verified,
        });

  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    return TherapistModel(
      id: json['_id'],
      name: json['FullName'],
      email: json['Email'],
      role: json['Role'] ?? "therapist",
      hasPassword: json['Password'] != null,
      bio: json['Bio'] ?? "",
      certificate: json['certificate'] ?? "",
      fee: json['fee'] ?? 0,
      rating: json['rating'] ?? 0.0,
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'FullName': name,
      'Email': email,
      'hasPassword': hasPassword,
      'Role': role,
      'bio': bio,
      'certificate': certificate,
      'fee': fee,
      'rating': rating,
      'verified': verified,
      
    };
  }
    }