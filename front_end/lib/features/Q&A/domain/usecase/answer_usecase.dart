import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/Q&A/domain/entity/answer_entity.dart';
import 'package:front_end/features/Q&A/domain/repository/answer_repository.dart';

class GetAnswersUsecase extends Usecase<List<AnswerEntity>, GetAnswerParams> {
  final AnswerRepository repository;

  GetAnswersUsecase(this.repository);

  @override
  Future<Either<Failure, List<AnswerEntity>>> call(GetAnswerParams params) async {
    return await repository.getAnswers(params.questionId);
  }
}

class GetAnswerParams{
  final String questionId;
  GetAnswerParams(this.questionId);

}
class AddAnswerUsecase extends Usecase<String, AddAnswerParams> {
  final AnswerRepository repository;
  AddAnswerUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(AddAnswerParams params) async {
    return await repository.createAnswer(params.answerEntity);
  }
}

class AddAnswerParams{
  final AnswerEntity answerEntity;
  AddAnswerParams(this.answerEntity);
}



class UpdateAnswerUsecase extends Usecase<String, UpdateAnswerParams> {
  final AnswerRepository repository;
  UpdateAnswerUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(UpdateAnswerParams params) async {
    return await repository.updateAnswer(params.answerEntity, params.id);
  }
}

class UpdateAnswerParams{
  final AnswerEntity answerEntity;
  final String id;
  UpdateAnswerParams(this.answerEntity, this.id);
}


class DeleteAnswerUsecase extends Usecase<String, DeleteAnswerParams> {
  final AnswerRepository repository;
  DeleteAnswerUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteAnswerParams params) async {
    return await repository.deleteAnswer(params.id);
  }
}

class DeleteAnswerParams {
  final String id;
  DeleteAnswerParams(this.id);
}