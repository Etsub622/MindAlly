part of 'chat_list_bloc.dart';


enum ChatStatus { loading, success, error }

@immutable
sealed class ChatListState {}

final class ChatListInitial extends ChatListState {}



class GetAllChatsState extends ChatListState {
  final ChatStatus status;
  final ListChatsEntity chats;

  GetAllChatsState({required this.status, required this.chats});
}

