
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile/data/models/patient_model.dart';
import 'package:front_end/features/profile/data/models/therapist_model.dart';
import 'package:front_end/features/profile/domain/entities/patient_entity.dart';
import 'package:front_end/features/profile/domain/entities/therapist_entity.dart';
import 'package:front_end/features/profile/domain/repository/profile_repository.dart';


class UpdateTherapistUsecase extends Usecase<TherapistModel, TherapistEntity> {
  final ProfileRepository repository;

  UpdateTherapistUsecase(this.repository);
  
  @override
  Future<Either<Failure, TherapistModel>> call(TherapistEntity therapist) async {
    return await repository.updateTherapist(therapist: therapist);
  }
}