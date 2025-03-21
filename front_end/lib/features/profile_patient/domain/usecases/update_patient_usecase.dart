
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile_patient/data/models/update_patient_model.dart';
import 'package:front_end/features/profile_patient/domain/repository/patient_profile_repository.dart';


class UpdatePatientUsecase extends Usecase<UpdatePatientModel, UpdatePatientModel> {
  final PatientProfileRepository repository;

  UpdatePatientUsecase(this.repository);
  
  @override
  Future<Either<Failure, UpdatePatientModel>> call(UpdatePatientModel params) async {
    return await repository.updatePatient(patient: params);
  }
}