
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile/data/models/patient_model.dart';
import 'package:front_end/features/profile/domain/repository/profile_repository.dart';


class GetPatientUsecase extends Usecase<PatientModel, String> {
  final ProfileRepository repository;

  GetPatientUsecase(this.repository);
  
  @override
  Future<Either<Failure, PatientModel>> call(String params) async {
    return await repository.getPatient(id: params);
  }
}