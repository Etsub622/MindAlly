import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/authentication/domain/entities/student_data.dart';
import 'package:front_end/features/authentication/domain/repositories/student_data_repo.dart';

class StudentUserUsecase extends Usecase<StudentUserEntity ,StudentParams> {
  final StudentDataRepo studentDataRepo;
  StudentUserUsecase({required this.studentDataRepo});

  @override
  Future<Either<Failure,StudentUserEntity>> call(StudentParams params) async {
    return await studentDataRepo.getStudentData();
  }
}



class StudentParams{}