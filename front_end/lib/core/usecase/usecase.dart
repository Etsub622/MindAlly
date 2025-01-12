import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure,Type>>call (Params params);
}

class NoParams{
  NoParams();
}