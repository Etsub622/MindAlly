
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/profile_patient/data/datasource/profile_local_datasource.dart';
import 'package:front_end/features/profile_therapist/data/datasource/therapist_profile_remote_datasource.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';
import 'package:front_end/features/profile_therapist/domain/repository/therapist_profile_repository.dart';



class TherapistProfileRepositoryImpl extends TherapistProfileRepository {
  final TherapistProfileRemoteDatasource remoteDatasource;
  final ProfileLocalDataSource localDatasource;
  final NetworkInfo networkInfo;


  TherapistProfileRepositoryImpl(
    {required this.remoteDatasource, required this.networkInfo, required this.localDatasource});  @override
  Future<Either<Failure, TherapistModel>> getTherapist({required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final therapist = await remoteDatasource.getTherapist(id: id);
        return Right(therapist);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }
    return Left(NetworkFailure(message: "No internet connection"));
  }


  @override
  Future<Either<Failure, TherapistModel>> createTherapist({required TherapistModel therapist}) async {
    if (await networkInfo.isConnected) {
      try {
        final createdTherapist = await remoteDatasource.createTherapist(therapist: therapist);
        return Right(createdTherapist);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: "Something went wrong"));
      }
    }
    return Left(NetworkFailure(message: "No internet connection"));
  }

  @override
  Future<Either<Failure, UpdateTherapistModel>> updateTherapist({required UpdateTherapistModel therapist}) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedTherapist = await remoteDatasource.updateTherapist(therapist: therapist);
        return Right(updatedTherapist);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: "Something went wrong"));
      }
    }
    return Left(NetworkFailure(message: "No internet connection"));
   
  }

  @override
  Future<Either<Failure, Null>> deleteTherapist({required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.deleteTherapist(id: id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: "Something went wrong"));
      }
    }
    return Left(NetworkFailure(message: "No internet connection"));
  }

}