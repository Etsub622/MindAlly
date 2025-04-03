part of 'answer_bloc.dart';

@immutable
sealed class AnswerEvent {
  const AnswerEvent();
}

class AddAnswerEvent extends AnswerEvent {
  final AnswerEntity answerEntity;
  AddAnswerEvent(this.answerEntity);
}

class GetAnswerEvent extends AnswerEvent {
  final String questionId;
  const GetAnswerEvent( this.questionId);
}

class DeleteAnswerEvent extends AnswerEvent {
  final String id;
  DeleteAnswerEvent(this.id);
}

class UpdateAnswerEvent extends AnswerEvent {
  final AnswerEntity answerEntity;
  final String id;
  UpdateAnswerEvent(this.answerEntity, this.id);
}
