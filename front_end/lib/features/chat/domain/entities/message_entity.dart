

import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String chatId ;
  final String message;
  final String senderId;
  final String receiverId;
  final DateTime timestamp;
  final bool isRead;

  const MessageEntity({
    required this.chatId,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
    senderId, receiverId, message, isRead, chatId, timestamp
  ];
} 