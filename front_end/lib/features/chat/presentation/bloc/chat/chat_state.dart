part of 'chat_bloc.dart';

enum ChatStatus { loading, success, error }

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoadingState extends ChatState {
  ChatLoadingState();
}

class ChatLoadedState extends ChatState {
  final List<MessageEntity> messages;

  ChatLoadedState({ required this.messages });
}

class ChatErrorState extends ChatState {
  final String errorMessage;  
  ChatErrorState({required this.errorMessage});
}  