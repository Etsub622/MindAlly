import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/Home/data/data_source/home_remote_data_source.dart';
import 'package:front_end/features/Home/domain/repostitory/home_respository.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';
class HomeRepositoryImpl extends HomeRespository {
  final HomeRemoteDataSource homeRemoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl(
      {required this.homeRemoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<UpdateTherapistModel>>> getMatchedTherapist(
      {required String patientId}) async {
    // if (await networkInfo.isConnected) {
      try {
        final result = await homeRemoteDataSource.getMatchedTherapist(
            patientId: patientId);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    // } else {
    //   return Left(NetworkFailure(message: 'No internet connection'));
    // }
  }

  @override
  Future<Either<Failure, List<UpdateTherapistModel>>> getAllTherapists() async {
    // if (await networkInfo.isConnected) {
      try {
        final result = await homeRemoteDataSource.getAllTherapists();
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    // } else {
    //   return Left(NetworkFailure(message: 'No internet connection'));
    // }
  }
}
