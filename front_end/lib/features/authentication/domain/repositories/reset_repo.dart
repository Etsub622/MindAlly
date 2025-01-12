import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:front_end/features/authentication/domain/entities/reset_password.dart';

abstract interface class ResetPasswordRepo {
  Future<Either<Failure, StudentResponseModel>> resetPassword(ResetPasswordEntity resetPassword);
}
