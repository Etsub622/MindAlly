import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/authentication/domain/entities/student_data.dart';

abstract class StudentDataRepo {
  Future<Either<Failure, StudentUserEntity>> getStudentData();
}