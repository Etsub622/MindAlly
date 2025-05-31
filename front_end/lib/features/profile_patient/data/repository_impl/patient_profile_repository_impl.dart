
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/profile_patient/data/datasource/patient_profile_remote_datasource.dart';
import 'package:front_end/features/profile_patient/data/datasource/profile_local_datasource.dart';
import 'package:front_end/features/profile_patient/data/models/patient_model.dart';
import 'package:front_end/features/profile_patient/data/models/update_patient_model.dart';
import 'package:front_end/features/profile_patient/domain/repository/patient_profile_repository.dart';


class PatientProfileRepositoryImpl extends PatientProfileRepository {
  final PatientProfileRemoteDatasource remoteDatasource;
  final ProfileLocalDataSource localDatasource;
  final NetworkInfo networkInfo;


  PatientProfileRepositoryImpl(
    {required this.remoteDatasource, required this.networkInfo, required this.localDatasource});

  @override
  Future<Either<Failure, PatientModel>> getPatient({required String id}) async {
    // if (await networkInfo.isConnected) {
      try {
        final patient = await remoteDatasource.getPatient(id: id);
        return Right(patient);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    }
    // return Left(NetworkFailure(message: "No internet connection"));
  // }
  @override
  Future<Either<Failure, UpdatePatientModel>> updatePatient({required UpdatePatientModel patient}) async {
    // if (await networkInfo.isConnected) {
      try {
        final updatedPatient = await remoteDatasource.updatePatient(patient: patient);
        return Right(updatedPatient);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: "Something went wrong"));
      }
    // }
    // return Left(NetworkFailure(message: "No internet connection"));
   
  }

  @override
  Future<Either<Failure, Null>> deletePatient({required String id}) async {
    // if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.deletePatient(id: id);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: "Something went wrong"));
      }
    // }
    // return Left(NetworkFailure(message: "No internet connection"));
  }
  
}