import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/approve_therapist/data/datasource/therapist_verify_ds.dart';
import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';
import 'package:front_end/features/approve_therapist/domain/repository/therapist_verify_repo.dart';

class TherapistVerifyRepoImpl implements TherapistVerifyRepository {
  final TherapistVerifyRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  TherapistVerifyRepoImpl(this.networkInfo, this.remoteDatasource);

  @override
  Future<Either<Failure, List<TherapistVerifyEntity>>>
      getTherapistsToVerify() async {
    // if (await networkInfo.isConnected) {
    try {
      final res = await remoteDatasource.getTherapists();
      final therapistEntity = res.map((e) => e.toEntity()).toList();
      return Right(therapistEntity);
    } on ServerException {
      return Left(ServerFailure(message: 'Server failure'));
    }
    // } else {
    //   return Left(
    //       NetworkFailure(message: 'You are not connected to the internet.'));
    // }
  }

  @override
  Future<Either<Failure, String>> rejectTherapist(
      String id, String reason) async {
    // if (await networkInfo.isConnected) {
    try {
      final res = await remoteDatasource.rejectTherapist(id, reason);
      return Right(res);
    } on ServerException {
      return Left(ServerFailure(message: 'Server failure'));
    }
    // } else {
    //   return Left(
    //       NetworkFailure(message: 'You are not connected to the internet.'));
    // }
  }

  @override
  Future<Either<Failure, String>> verifyTherapist(String id) async {
    // if (await networkInfo.isConnected) {
    try {
      final res = await remoteDatasource.verifyTherapist(id);
      return Right(res);
    } on ServerException {
      return Left(ServerFailure(message: 'Server failure'));
    }
    // } else {
    //   return Left(
    //       NetworkFailure(message: 'You are not connected to the internet.'));
    // }
  }
}
