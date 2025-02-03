
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile/data/models/therapist_model.dart';
import 'package:front_end/features/profile/domain/repository/profile_repository.dart';


class GetTherapistUsecase extends Usecase<TherapistModel, String> {
  final ProfileRepository repository;

  GetTherapistUsecase(this.repository);
  
  @override
  Future<Either<Failure, TherapistModel>> call(String params) async {
    return await repository.getTherapist(id: params);
  }
}