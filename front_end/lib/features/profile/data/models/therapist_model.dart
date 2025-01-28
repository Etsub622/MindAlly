

import 'package:front_end/features/profile/data/models/user_model.dart';
import 'package:front_end/features/profile/domain/entities/therapist_entity.dart';

class   TherapistModel extends TherapistEntity {

  const TherapistModel({
    required super.userEntity, 
    required super.bio,
    required super.certificate,
    required super.fee,
    required super.rating,
    required super.verified,
        });

  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    return TherapistModel(
      userEntity: UserModel.fromJson(json['userEntity']),
      bio: json['bio'],
      certificate: json['certificate'],
      fee: json['fee'],
      rating: json['rating'],
      verified: json['verified'],
    );
  }
    }