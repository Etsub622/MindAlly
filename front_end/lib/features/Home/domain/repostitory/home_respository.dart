import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';

abstract class HomeRespository {
  Future<Either<Failure, List<UpdateTherapistModel>>> getMatchedTherapist({required String patientId});
}