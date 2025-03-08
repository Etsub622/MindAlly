import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUsecase extends Usecase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      message: params.message,
      senderId: params.senderId,
      receiverId: params.receiverId,
      chatId: params.chatId,
    );
  }
}

class SendMessageParams {
  final String message;
  final String senderId;
  final String receiverId;
  final String chatId;

  SendMessageParams({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.chatId,
  });
}
