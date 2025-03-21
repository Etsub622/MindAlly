
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile_patient/domain/repository/patient_profile_repository.dart';

class DeletePatientUsecase extends Usecase<Null, String> {
  final PatientProfileRepository repository;

  DeletePatientUsecase(this.repository);

  @override
  Future<Either<Failure, Null>> call(String params) async {
    return await repository.deletePatient(id: params);
  }
}