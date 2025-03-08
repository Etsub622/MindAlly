part of 'chat_bloc.dart';

enum ChatStatus { loading, success, error }

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class SendChatState extends ChatState {
  final ChatStatus status;
  SendChatState({required this.status});
}

class GetAllChatsState extends ChatState {
  final ChatStatus status;
  final List<ChatsEntity>? chats;

  GetAllChatsState({required this.status, this.chats});
}

class GetSingleChatState extends ChatState {
  final ChatStatus status;
  final List<SingleChatEntity>? chats;

  GetSingleChatState({required this.status, this.chats});
}
