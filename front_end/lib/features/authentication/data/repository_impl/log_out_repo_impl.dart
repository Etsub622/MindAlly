import 'package:dartz/dartz.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/authentication/data/datasource/auth_local_datasource/login_local_datasource.dart';
import 'package:front_end/features/authentication/data/datasource/auth_remote_datasource/auth_remote_datasource.dart';
import 'package:front_end/features/authentication/domain/repositories/log_out_repo.dart';

class LogOutRepoImpl extends LogOutRepo {
  final AuthRemoteDatasource authRemoteDatasource;
  final NetworkInfo networkInfo;
  final LoginLocalDataSource loginLocalDataSource;

  LogOutRepoImpl({
    required this.authRemoteDatasource,
    required this.networkInfo,
    required this.loginLocalDataSource,
  });
  @override
  Future<Either<Failure, String>> logOut() async {
      try {
        await loginLocalDataSource.deleteUser();
        return Right('Logged out successfully');
      } on ServerException {
        return Left(ServerFailure(message: 'Server Failure'));
      } on CacheException {
        return Left(CacheFailure(message: 'Cache Failure'));
      }
  }
}
