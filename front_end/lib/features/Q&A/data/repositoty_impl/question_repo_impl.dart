import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/Q&A/data/datasource/question_remote_datasource.dart';
import 'package:front_end/features/Q&A/data/model/question_model.dart';
import 'package:front_end/features/Q&A/domain/entity/question_entity.dart';
import 'package:front_end/features/Q&A/domain/repository/question_repository.dart';

class QuestionRepoImpl implements QuestionRepository {
  final QuestionRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  QuestionRepoImpl(this.networkInfo, this.remoteDatasource);

  @override
  Future<Either<Failure, String>> createQuestion(
      QuestionEntity question) async {
    if (await networkInfo.isConnected) {
      try {
        final newQuestion = QuestionModel(
          id: '',
          category: question.category,
          description: question.description,
          studentName: question.studentName,
          studentProfile: question.studentProfile,
          title: question.title,
        );
        final res = await remoteDatasource.addQuestion(newQuestion);
        return right(res);
      } on Exception {
        return (Left(ServerFailure(message: 'server failure')));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteQuestion(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.deleteQuestion(id);
        return Right(res);
      } on Exception {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }

  @override
  Future<Either<Failure, List<QuestionEntity>>> getQuestions() async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.getQuestions();
        final questionEntity = res.map((book) => book.toEntity()).toList();
        return Right(questionEntity);
      } on Exception {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }

  @override
 Future<Either<Failure, List<QuestionEntity>>> getQuestionsByCategory(
      String category) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.getQuestionbyCategory(category);
        final questionEntity =
            res.map((question) => question.toEntity()).toList();
        return Right(questionEntity);
      } on Exception {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }

  @override
  Future<Either<Failure, String>> updateQuestion(
      QuestionEntity question, String id) async {
    if (await networkInfo.isConnected) {
      try {
        final newQuestion = QuestionModel(
          id: id,
          category: question.category,
          description: question.description,
          studentName: question.studentName,
          studentProfile: question.studentProfile,
          title: question.title,
        );
        final res = await remoteDatasource.updateQuestion(newQuestion, id);
        return right(res);
      } on Exception {
        return (Left(ServerFailure(message: 'server failure')));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }
}
