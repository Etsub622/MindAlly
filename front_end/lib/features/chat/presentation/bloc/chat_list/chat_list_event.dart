part of 'chat_list_bloc.dart';

@immutable
sealed class ChatListEvent {}

class GetChatListEvent extends ChatListEvent {}

class GetAllChatsEvent extends ChatListEvent {
  GetAllChatsEvent();
}

