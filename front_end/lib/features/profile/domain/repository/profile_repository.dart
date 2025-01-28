

import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/profile/data/models/patient_model.dart';
import 'package:front_end/features/profile/data/models/therapist_model.dart';
import 'package:front_end/features/profile/domain/entities/patient_entity.dart';
import 'package:front_end/features/profile/domain/entities/therapist_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, PatientModel>> getPatientProfile();
  Future<Either<Failure, TherapistModel>> getTherapistProfile();
  Future<Either<Failure, String>> updatePatientProfile(PatientEntity profile);
  Future<Either<Failure, String>> updateTherapistProfile(TherapistEntity profile);
}