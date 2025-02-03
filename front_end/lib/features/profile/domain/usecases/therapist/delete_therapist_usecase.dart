
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile/domain/repository/profile_repository.dart';

class DeleteTherapistUsecase extends Usecase<Null, String> {
  final ProfileRepository repository;

  DeleteTherapistUsecase(this.repository);

  @override
  Future<Either<Failure, Null>> call(String params) async {
    return await repository.deleteTherapist(id: params);
  }
}