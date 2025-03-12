
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/profile/data/models/user_model.dart';
import 'package:front_end/features/profile/domain/entities/user_entity.dart';

class ChatsModel extends ChatsEntity {
  const ChatsModel({
      required super.chatId,
      required super.senderId,
      required super.receiverId,
      required super.unReadCount,
      required super.lastMessage,
      required super.lastMessageTime,
      required super.receiver,
  });

  factory ChatsModel.fromJson(Map<String, dynamic> json) {
    return ChatsModel(
      chatId: json['chatId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      unReadCount: json['countOfUnreadMessage'] ?? 0,
      lastMessageTime: json['lastMessageTime'],
      receiver: UserModel.fromJson(json['secondUser'] as Map<String, dynamic>),
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'countOfUnreadMessage': unReadCount,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'secondUser': receiver,
    };
  }

  ChatsModel copyWith({
    String? chatId,
    String? senderId,
    String? receiverId,
    UserEntity? receiver,
    int? unReadCount,
    String? lastMessage,
    String? lastMessageTime,
  }) {
    return ChatsModel(
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      receiver: receiver ?? this.receiver,
      unReadCount: unReadCount ?? this.unReadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }
}
