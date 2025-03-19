
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';
import 'package:front_end/features/profile_therapist/domain/repository/therapist_profile_repository.dart';

class UpdateTherapistUsecase extends Usecase<UpdateTherapistModel, UpdateTherapistModel> {
  final TherapistProfileRepository repository;

  UpdateTherapistUsecase(this.repository);
  
  @override
  Future<Either<Failure, UpdateTherapistModel>> call(UpdateTherapistModel params) async {
    return await repository.updateTherapist(therapist: params);
  }
}