import 'package:front_end/features/chat/domain/entities/message_entity.dart';


class MessageModel extends MessageEntity {
  const MessageModel({
    required super.chatId,
    required super.message,
    required super.senderId,
    required super.timestamp,
    required super.isRead, 
    required super.receiverId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      chatId: json["chatId"],
      message: json["message"],
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      timestamp: json["timestamp"] != null ? DateTime.parse(json["timestamp"]) : DateTime.now(),
      isRead: json["isRead"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "message": message,
      "senderId": senderId,
      "receiverId": receiverId,
      "isRead": isRead,
      "timestamp": timestamp.toIso8601String(),
    };
  }

  MessageModel copyWith({
    String? chatId,
    String? message,
    String? senderId,
    String? receiverId,
    bool? isRead,
    DateTime? timestamp,

  }) {
    return MessageModel(
      chatId: chatId ?? this.chatId,
      message: message ?? this.message,
      receiverId: receiverId ?? this.receiverId,
      isRead: isRead ?? this.isRead,
      senderId: senderId ?? this.senderId,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
