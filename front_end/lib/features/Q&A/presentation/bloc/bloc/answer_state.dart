part of 'answer_bloc.dart';

@immutable
sealed class AnswerState {}

final class AnswerInitial extends AnswerState {}

class AnswerLoading extends AnswerState {}

class AnswerLoaded extends AnswerState {
  final List<AnswerEntity> answers;
  AnswerLoaded(this.answers);
}

class AnswerError extends AnswerState {
  final String message;
  AnswerError(this.message);
}

class AnswerAdded extends AnswerState {
  final String message;
  AnswerAdded(this.message);
}

class AnswerUpdated extends AnswerState {
  final String message;
  AnswerUpdated(this.message);
}

class AnswerDeleted extends AnswerState {
  final String message;
  AnswerDeleted(this.message);
}
