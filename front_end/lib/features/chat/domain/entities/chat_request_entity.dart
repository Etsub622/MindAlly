import 'package:equatable/equatable.dart';

class ChatRequestEntity extends Equatable {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final List<String>? attachements;
  final String caption;
  final bool isRead;

  const ChatRequestEntity({
      required this.chatId, 
      required this.senderId,
      required this.receiverId,
      required this.message,
      this.attachements = const [],
      this.caption = "",
      required this.isRead,
      
  });

  @override
  List<Object?> get props => [
    chatId, senderId, receiverId, message, isRead
  ];


}