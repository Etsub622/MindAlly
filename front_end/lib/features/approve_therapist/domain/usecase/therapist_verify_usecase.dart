
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';
import 'package:front_end/features/approve_therapist/domain/repository/therapist_verify_repo.dart';

class TherapistVerifyUsecase extends Usecase<String, VerifyTherapistParams> {
  final TherapistVerifyRepository repository;
  TherapistVerifyUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyTherapistParams params) async {
    return await repository.verifyTherapist(params.id);
  }
}

class VerifyTherapistParams {
  final String id;
  VerifyTherapistParams({
    required this.id,
  });
}

class RejectTherapistUsecase extends Usecase<String, RejectTherapistParams> {
  final TherapistVerifyRepository repository;
  RejectTherapistUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(RejectTherapistParams params) async {
    return await repository.rejectTherapist(params.id, params.reason);
  }
}
class RejectTherapistParams {
  final String id;
  final String reason;
  RejectTherapistParams({
    required this.id,
    required this.reason,
  });
}


  class GetTherapistsToVerifyUsecase extends Usecase<List<TherapistVerifyEntity>, NoParams> {
  final TherapistVerifyRepository repository;
  GetTherapistsToVerifyUsecase(this.repository);
  @override
  Future<Either<Failure, List<TherapistVerifyEntity>>> call(NoParams params) async {
    return await repository.getTherapistsToVerify();
  }
}

