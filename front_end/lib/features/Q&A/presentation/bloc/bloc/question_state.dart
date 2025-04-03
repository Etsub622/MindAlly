part of 'question_bloc.dart';

@immutable
sealed class QuestionState {}

final class QuestionInitial extends QuestionState {}
class QuestionLoading extends QuestionState {}

class QuestionLoaded extends QuestionState {
  final List<QuestionEntity> questions;
  QuestionLoaded(this.questions);
}

class QuestionError extends QuestionState {
  final String message;
  QuestionError(this.message);
}

class QuestionAdded extends QuestionState {
  final String message;
  QuestionAdded(this.message);
}

class QuestionUpdated extends QuestionState {
  final String message;
  QuestionUpdated(this.message);
}

class QuestionDeleted extends QuestionState {
  final String message;
  QuestionDeleted(this.message);
}

class SearchFailed extends QuestionState {
  final String message;
  SearchFailed(this.message);
}
