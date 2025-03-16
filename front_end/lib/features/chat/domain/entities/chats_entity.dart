import 'package:equatable/equatable.dart';
import 'package:front_end/features/profile/domain/entities/user_entity.dart';

class ChatsEntity extends Equatable {
  final String chatId;
  final String receiverId;
  final String senderId;
  final int unReadCount;
  final String lastMessage;
  final String lastMessageTime;
  final UserEntity receiver;

  const ChatsEntity({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.unReadCount,
    required this.lastMessage,
    required this.receiver,
    required this.lastMessageTime,
  });

  @override
  List<Object?> get props => [
        chatId,
        senderId,
        unReadCount,
        lastMessage,
        lastMessageTime,
        receiver,
      ];
}
