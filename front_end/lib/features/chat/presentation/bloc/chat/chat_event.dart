part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class GetChatsEvent extends ChatEvent {}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  LoadMessagesEvent({required this.chatId});
}

class SendChatEvent extends ChatEvent {
  final MessageModel messageModel;

  SendChatEvent({required this.messageModel});
}


class ReceiveChatEvent extends ChatEvent {
  final MessageEntity message;
  ReceiveChatEvent({ required this.message });
}
class GetAllChatsEvent extends ChatEvent {

  GetAllChatsEvent();
}

