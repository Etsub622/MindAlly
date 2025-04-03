part of 'question_bloc.dart';

@immutable
sealed class QuestionEvent {
  const QuestionEvent();
}

class AddQuestionEvent extends QuestionEvent {
  final QuestionEntity questionEntity;
  AddQuestionEvent(this.questionEntity);
}

class GetQuestionEvent extends QuestionEvent {
  const GetQuestionEvent();
}

class DeleteQuestionEvent extends QuestionEvent {
  final String id;
  DeleteQuestionEvent(this.id);
}

class UpdateQuestionEvent extends QuestionEvent {
  final QuestionEntity questionEntity;
  final String id;
  UpdateQuestionEvent(this.questionEntity, this.id);
}

class SearchQuestionEvent extends QuestionEvent {
  final String title;
  SearchQuestionEvent(this.title);
}


