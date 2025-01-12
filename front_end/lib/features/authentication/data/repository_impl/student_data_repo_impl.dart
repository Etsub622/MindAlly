import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/authentication/data/datasource/auth_local_datasource/login_local_datasource.dart';
import 'package:front_end/features/authentication/data/datasource/auth_remote_datasource/auth_remote_datasource.dart';
import 'package:front_end/features/authentication/domain/entities/student_data.dart';
import 'package:front_end/features/authentication/domain/repositories/student_data_repo.dart';

class GetStudentDataRepoImpl extends StudentDataRepo {
  final LoginLocalDataSource loginLocalDataSource;
  final NetworkInfo networkInfo;
  final AuthRemoteDatasource authRemoteDatasource;

  GetStudentDataRepoImpl(
      {required this.loginLocalDataSource, required this.networkInfo, required this.authRemoteDatasource});

  @override
  Future<Either<Failure, StudentUserEntity>> getStudentData()async {
    if (await networkInfo.isConnected) {
      try {
        final studentData = await loginLocalDataSource.getUser();
        return Right(studentData!);
      } on ServerException {
        return Left(ServerFailure(message: 'Server Failure'));
      }
    } else {
      return Left(NetworkFailure(message: 'You are not connected to the internet'));
    }
    
  }
}
