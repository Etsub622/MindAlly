

import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/profile/data/models/patient_model.dart';
import 'package:front_end/features/profile/data/models/therapist_model.dart';
import 'package:front_end/features/profile/domain/entities/patient_entity.dart';
import 'package:front_end/features/profile/domain/entities/therapist_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, PatientModel>> getPatient({required String id});
  Future<Either<Failure, PatientModel>> createPatient({required PatientEntity patient});
  Future<Either<Failure, PatientModel>> updatePatient({required PatientEntity patient});
  Future<Either<Failure, Null>> deletePatient({required String id});

  
  Future<Either<Failure, TherapistModel>> getTherapist({required String id});
  Future<Either<Failure, TherapistModel>> createTherapist({required TherapistEntity therapist});
  Future<Either<Failure, TherapistModel>> updateTherapist({required TherapistEntity therapist});
  Future<Either<Failure, Null>> deleteTherapist({required String id});

}