import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/Q&A/domain/entity/answer_entity.dart';

abstract interface class AnswerRepository {
  Future<Either<Failure, String>> createAnswer(AnswerEntity answer);
  Future<Either<Failure, String>> updateAnswer(AnswerEntity answer, String id);
  Future<Either<Failure, String>> deleteAnswer(String id);
  Future<Either<Failure, List<AnswerEntity>>> getAnswers();
}