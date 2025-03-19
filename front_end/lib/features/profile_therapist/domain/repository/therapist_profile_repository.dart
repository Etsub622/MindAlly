import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';

abstract class TherapistProfileRepository {
   Future<Either<Failure, TherapistModel>> getTherapist({required String id});
  Future<Either<Failure, TherapistModel>> createTherapist({required TherapistModel therapist});
  Future<Either<Failure, UpdateTherapistModel>> updateTherapist({required UpdateTherapistModel therapist});
  Future<Either<Failure, Null>> deleteTherapist({required String id});

}