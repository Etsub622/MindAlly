
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';

abstract class TherapistVerifyRepository {
  Future<Either<Failure, List<TherapistVerifyEntity>>> getTherapistsToVerify();
  Future<Either<Failure,String>> verifyTherapist(String id);
  Future<Either<Failure, String>> rejectTherapist(String id, String reason);
}