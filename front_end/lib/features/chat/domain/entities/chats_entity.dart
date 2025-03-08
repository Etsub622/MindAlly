import 'package:equatable/equatable.dart';
import 'package:front_end/core/mock_data/chat_data.dart';

class ChatsEntity extends Equatable {
  final String chatId;
  final String chatName;
  final List<String> participantDetails;
  final String lastMessage;
  final String lastMessageTime;
  final ChatType chatType;
  final bool isRead;

  const ChatsEntity({
    required this.chatId,
    required this.chatName,
    required this.participantDetails,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.chatType,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
        chatId,
        chatName,
        participantDetails,
        lastMessage,
        lastMessageTime,
        isRead,
        chatType
      ];
}
