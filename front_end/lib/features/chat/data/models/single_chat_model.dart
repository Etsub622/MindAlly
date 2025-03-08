import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';

class SingleChatModel extends SingleChatEntity {
  const SingleChatModel({
    required super.message,
    required super.messageId,
    required super.dataType,
    required super.dataUrl,
    required super.senderId,
    required super.timestamp,
  });

  factory SingleChatModel.fromJson(Map<String, dynamic> json) {
    return SingleChatModel(
      message: json["message"],
      messageId: json["messageId"],
      dataType: json["dataType"],
      dataUrl: json["dataUrl"],
      senderId: json["senderId"],
      timestamp: json["timestamp"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "messageId": messageId,
      "dataType": dataType,
      "dataUrl": dataUrl,
      "senderId": senderId,
      "timestamp": timestamp,
    };
  }

  SingleChatModel copyWith({
    String? message,
    String? messageId,
    String? dataType,
    String? dataUrl,
    String? senderId,
    String? timestamp,
  }) {
    return SingleChatModel(
      message: message ?? this.message,
      messageId: messageId ?? this.messageId,
      dataType: dataType ?? this.dataType,
      dataUrl: dataUrl ?? this.dataUrl,
      senderId: senderId ?? this.senderId,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
