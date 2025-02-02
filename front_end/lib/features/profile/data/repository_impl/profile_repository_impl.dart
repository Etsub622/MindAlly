
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/profile/data/datasource/profile_remote_datasource.dart';
import 'package:front_end/features/profile/data/models/patient_model.dart';
import 'package:front_end/features/profile/data/models/therapist_model.dart';
import 'package:front_end/features/profile/domain/entities/patient_entity.dart';
import 'package:front_end/features/profile/domain/entities/therapist_entity.dart';
import 'package:front_end/features/profile/domain/repository/profile_repository.dart';


class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;


  ProfileRepositoryImpl(
    {required this.remoteDatasource, required this.networkInfo});

  @override
  Future<Either<Failure, PatientModel>> getPatient({required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        final patient = await remoteDatasource.getPatient(id: id);
        return Right(patient);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }
    return Left(NetworkFailure(message: "No internet connection"));
  }


  @override
  Future<Either<Failure, PatientModel>> createPatient({required PatientEntity patient}) async {
    if (await networkInfo.isConnected) {
      try {
        final createdPatient = await remoteDatasource.createPatient(patient: patient);
        return Right(createdPatient);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: "Something went wrong"));
      }
    }
    return Left(NetworkFailure(message: "No internet connection"));
  }

  @override
  Future<Either<Failure, PatientModel>> updatePatient({required PatientEntity patient}) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedPatient = await remoteDatasource.updatePatient(patient: patient);
        return Right(updatedPatient);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: "Something went wrong"));
      }
    }
    return Left(NetworkFailure(message: "No internet connection"));
   
  }

  @override
  Future<Either<Failure, Null>> deletePatient({required String id}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.deletePatient(id: id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: "Something went wrong"));
      }
    }
    return Left(NetworkFailure(message: "No internet connection"));
  }

   @override
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
  Future<Either<Failure, TherapistModel>> createTherapist({required TherapistEntity therapist}) async {
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
  Future<Either<Failure, TherapistModel>> updateTherapist({required TherapistEntity therapist}) async {
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