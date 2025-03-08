part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class GetChatsEvent extends ChatEvent {}

class SendChatEvent extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String chatId;
  final String message;

  SendChatEvent(
      {required this.message,
      required this.receiverId,
      required this.chatId,
      required this.senderId});
}

class GetAllChatsEvent extends ChatEvent {
  final String userId;

  GetAllChatsEvent({required this.userId});
}

class GetSingleChatEvent extends ChatEvent {
  final String chatId;

  GetSingleChatEvent({required this.chatId});
}
