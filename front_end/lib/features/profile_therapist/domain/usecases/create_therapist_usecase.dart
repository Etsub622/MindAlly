import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/domain/repository/therapist_profile_repository.dart';


class CreateTherapistUsecase extends Usecase<TherapistModel, TherapistModel> {
  final TherapistProfileRepository repository;

  CreateTherapistUsecase(this.repository);
  
  @override
  Future<Either<Failure, TherapistModel>> call(TherapistModel params) async {
    return await repository.createTherapist(therapist: params);
  }
}