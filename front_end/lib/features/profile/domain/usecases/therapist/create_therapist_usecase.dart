import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile/data/models/therapist_model.dart';
import 'package:front_end/features/profile/domain/entities/therapist_entity.dart';
import 'package:front_end/features/profile/domain/repository/profile_repository.dart';


class CreateTherapistUsecase extends Usecase<TherapistModel, TherapistEntity> {
  final ProfileRepository repository;

  CreateTherapistUsecase(this.repository);
  
  @override
  Future<Either<Failure, TherapistModel>> call(TherapistEntity therapist) async {
    return await repository.createTherapist(therapist: therapist);
  }
}