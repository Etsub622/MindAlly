import 'package:equatable/equatable.dart';

class SingleChatEntity extends Equatable {
  final String messageId;
  final String dataType;
  final String message;
  final String? dataUrl;
  final String senderId;
  final String timestamp;

  const SingleChatEntity({
    this.dataUrl,
    required this.messageId,
    required this.message,
    required this.dataType,
    required this.senderId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        message,
        messageId,
        dataType,
        dataUrl,
        senderId,
        timestamp,
      ];
}
