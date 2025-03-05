import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/Q&A/domain/entity/question_entity.dart';

abstract interface class QuestionRepository {
  Future<Either<Failure, String>> createQuestion(QuestionEntity question);
  Future<Either<Failure, String>> updateQuestion(QuestionEntity question, String id);
  Future<Either<Failure, String>> deleteQuestion(String id);
  Future<Either<Failure, List<QuestionEntity>>> getQuestions();
  Future<Either<Failure, List<QuestionEntity>>> getQuestionsByCategory(String category);
}
