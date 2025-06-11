import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/Q&A/data/datasource/answer_remote_datasource.dart';
import 'package:front_end/features/Q&A/data/model/answer_model.dart';
import 'package:front_end/features/Q&A/domain/entity/answer_entity.dart';
import 'package:front_end/features/Q&A/domain/repository/answer_repository.dart';

class AnswerRepoImpl implements AnswerRepository {
  final AnswerRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  AnswerRepoImpl(this.networkInfo, this.remoteDatasource);

  @override
  Future<Either<Failure, String>> createAnswer(AnswerEntity answer) async {
    // if (await networkInfo.isConnected) {
      try {
        final newAnswer = AnswerModel(
          id: '',
          questionId: answer.questionId,
          answer: answer.answer,
          therapistName: answer.therapistName,
          therapistProfile: answer.therapistProfile,
        );
        final res = await remoteDatasource.addAnswer(newAnswer);
        return right(res);
      } on Exception {
        return (Left(ServerFailure(message: 'server failure')));
      }
    // } else {
    //   return Left(
    //       NetworkFailure(message: 'You are not connected to the internet.'));
    // }
  }

  @override
  Future<Either<Failure, String>> deleteAnswer(String id) async {
    // if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.deleteAnswer(id);
        return Right(res);
      } on Exception {
        return Left(ServerFailure(message: 'server failure'));
      }
    // } else {
    //   return Left(
    //       NetworkFailure(message: 'You are not connected to the internet.'));
    // }
  }

  @override
  Future<Either<Failure, List<AnswerEntity>>> getAnswers(
      String questionId) async {
    // if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.getAnswers(questionId);
        final answerEntity = res.map((book) => book.toEntity()).toList();
        print(answerEntity);
        return Right(answerEntity);
      } on Exception {
        return Left(ServerFailure(message: 'server failure'));
      }
    // } else {
    //   return Left(
    //       NetworkFailure(message: 'You are not connected to the internet.'));
    // }
  }

  @override
  Future<Either<Failure, String>> updateAnswer(
      AnswerEntity answer, String id) async {
    // if (await networkInfo.isConnected) {
      try {
        final newAnswer = AnswerModel(
          id: id,
          questionId: answer.questionId,
          answer: answer.answer,
          therapistName: answer.therapistName,
          therapistProfile: answer.therapistProfile,
        );
        final res = await remoteDatasource.updateAnswer(newAnswer, id);
        return right(res);
      } on Exception {
        return (Left(ServerFailure(message: 'server failure')));
      }
    // } else {
    //   return Left(
    //       NetworkFailure(message: 'You are not connected to the internet.'));
    // }
  }
}
