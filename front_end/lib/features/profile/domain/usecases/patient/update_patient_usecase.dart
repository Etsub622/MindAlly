
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/profile/data/models/patient_model.dart';
import 'package:front_end/features/profile/domain/entities/patient_entity.dart';
import 'package:front_end/features/profile/domain/repository/profile_repository.dart';


class UpdatePatientUsecase extends Usecase<PatientModel, PatientEntity> {
  final ProfileRepository repository;

  UpdatePatientUsecase(this.repository);
  
  @override
  Future<Either<Failure, PatientModel>> call(PatientEntity patient) async {
    return await repository.updatePatient(patient: patient);
  }
}