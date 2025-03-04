import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/Q&A/domain/entity/question_entity.dart';
import 'package:front_end/features/Q&A/domain/repository/question_repository.dart';

class GetQuestionsUsecase extends Usecase<List<QuestionEntity>,NoParams>{
  final QuestionRepository repository;

  GetQuestionsUsecase(this.repository);

   @override
  Future<Either<Failure, List<QuestionEntity>>> call(NoParams params) async {
    return await repository.getQuestions();
  }

}


class GetQuestionByCatetoryUsecase extends Usecase<List<QuestionEntity>, GetQuestionByCategoryParams>{
  final QuestionRepository repository;
  GetQuestionByCatetoryUsecase(this.repository);

  @override
  Future<Either<Failure, List<QuestionEntity>>> call(GetQuestionByCategoryParams params) async {
    return await repository.getQuestionsByCategory(params.category);
  }
}

class GetQuestionByCategoryParams{
  final String category;
  GetQuestionByCategoryParams(this.category);
}



class CreateQuestionUsecase extends Usecase<String, CreateQuestionParams>{
  final QuestionRepository repository;
  CreateQuestionUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateQuestionParams params) async {
    return await repository.createQuestion(params.questionEntity);
  }
}

class CreateQuestionParams{
  final QuestionEntity questionEntity;
  CreateQuestionParams(this.questionEntity);
}



class UpdateQuestionUsecase extends Usecase<String, UpdateQuestionParams>{
  final QuestionRepository repository;
  UpdateQuestionUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(UpdateQuestionParams params) async {
    return await repository.updateQuestion(params.questionEntity, params.id);
  }
}

class UpdateQuestionParams{
  final QuestionEntity questionEntity;
  final String id;
  UpdateQuestionParams(this.questionEntity, this.id);
}



class DeleteQuestionUsecase extends Usecase<String, DeleteQuestionParams>{
  final QuestionRepository repository;
  DeleteQuestionUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteQuestionParams params) async {
    return await repository.deleteQuestion(params.id);
  }
}

class DeleteQuestionParams {
  final String id;
  DeleteQuestionParams(this.id);
}


