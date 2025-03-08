
import 'package:front_end/core/mock_data/chat_data.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';

class ChatsModel extends ChatsEntity {
  const ChatsModel({
    required super.chatName,
    required super.participantDetails,
    required super.lastMessageTime,
    required super.chatType,
    required super.isRead,
    required super.chatId,
    required super.lastMessage,
  });

  factory ChatsModel.fromJson(Map<String, dynamic> json) {
    return ChatsModel(
      chatId: json['chatId'],
      chatName: json['chatName'],
      participantDetails: json['participantDetails'],
      lastMessageTime: json['timestamp'],
      chatType: json['chatType'],
      isRead: json['isRead'],
      lastMessage: json['lastMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'chatName': chatName,
      'participantDetails': participantDetails,
      'timestamp': lastMessageTime,
      'chatType': chatType,
      'isRead': isRead,
      'lastMessage': lastMessage,
    };
  }

  ChatsModel copyWith({
    String? chatId,
    String? chatName,
    List<String>? participantDetails,
    String? lastMessage,
    String? lastMessageTime,
    ChatType? chatType,
    bool? isRead,
  }) {
    return ChatsModel(
      chatId: chatId ?? this.chatId,
      chatName: chatName ?? this.chatName,
      participantDetails: participantDetails ?? this.participantDetails,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      chatType: chatType ?? this.chatType,
      isRead: isRead ?? this.isRead,
    );
  }
}
