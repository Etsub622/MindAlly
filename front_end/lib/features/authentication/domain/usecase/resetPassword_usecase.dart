import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:front_end/features/authentication/domain/entities/reset_password.dart';
import 'package:front_end/features/authentication/domain/repositories/reset_repo.dart';

class ResetpasswordUsecase extends Usecase<StudentResponseModel, ResetParams> {
  final ResetPasswordRepo resetPasswordRepo;
  ResetpasswordUsecase(this.resetPasswordRepo);

  @override
  Future<Either<Failure, StudentResponseModel>> call(ResetParams params) async {
    return await resetPasswordRepo.resetPassword(params.resetPasswordEntity);
  }
}

class ResetParams {
  final ResetPasswordEntity resetPasswordEntity;
  ResetParams(this.resetPasswordEntity);
}