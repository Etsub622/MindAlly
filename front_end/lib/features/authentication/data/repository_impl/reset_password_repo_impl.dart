import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/authentication/data/datasource/reset_password_remote_datasource.dart';
import 'package:front_end/features/authentication/data/models/reset_password_model.dart';
import 'package:front_end/features/authentication/domain/entities/reset_password.dart';
import 'package:front_end/features/authentication/domain/repositories/reset_repo.dart';

class ResetPasswordRepoImpl implements ResetPasswordRepo {
  final ResetPasswordRemoteDatasource resetPasswordRemoteDatasource;
  final NetworkInfo networkInfo;
  ResetPasswordRepoImpl(
      {required this.resetPasswordRemoteDatasource, required this.networkInfo});

  @override
  Future<Either<Failure, String>> resetPassword(
      ResetPasswordEntity resetPassword) async {
    if (await networkInfo.isConnected) {
      try {
        final user = ResetPasswordModel(
            resetToken: resetPassword.resetToken,
            newPassword: resetPassword.newPassword);
        final response =
            await resetPasswordRemoteDatasource.resetPassword(user);
        print(response);
        return Right(response);
      } on ServerException {
        return Left(ServerFailure(message: 'Server Failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet'));
    }
  }
}
