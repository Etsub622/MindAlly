
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile_patient/data/models/patient_model.dart';
import 'package:front_end/features/profile_patient/domain/repository/patient_profile_repository.dart';


class GetPatientUsecase extends Usecase<PatientModel, String> {
  final PatientProfileRepository repository;

  GetPatientUsecase(this.repository);
  
  @override
  Future<Either<Failure, PatientModel>> call(String params) async {
    return await repository.getPatient(id: params);
  }
}