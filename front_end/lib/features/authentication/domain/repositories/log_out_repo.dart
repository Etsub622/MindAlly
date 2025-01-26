import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';

abstract class LogOutRepo {
  Future<Either<Failure, String>> logOut();
}