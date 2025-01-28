

import 'package:front_end/features/profile/data/models/user_model.dart';
import 'package:front_end/features/profile/domain/entities/patient_entity.dart';

class   PatientModel extends PatientEntity {
  const PatientModel({
    required super.userEntity, 
    required super.collage,
        });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      userEntity: UserModel.fromJson(json['userEntity']),
      collage: json['collage'],
    );
  }
    }