

import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/profile_patient/data/models/patient_model.dart';
import 'package:front_end/features/profile_patient/data/models/update_patient_model.dart';


abstract class PatientProfileRepository {
  Future<Either<Failure, PatientModel>> getPatient({required String id});
  Future<Either<Failure, UpdatePatientModel>> updatePatient({required UpdatePatientModel patient});
  Future<Either<Failure, Null>> deletePatient({required String id});
}