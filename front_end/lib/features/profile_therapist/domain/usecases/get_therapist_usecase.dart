
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/domain/repository/therapist_profile_repository.dart';


class GetTherapistUsecase extends Usecase<TherapistModel, String> {
  final TherapistProfileRepository repository;

  GetTherapistUsecase(this.repository);
  
  @override
  Future<Either<Failure, TherapistModel>> call(String params) async {
    return await repository.getTherapist(id: params);
  }
}