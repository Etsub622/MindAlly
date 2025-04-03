import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/chat/data/models/single_chat_model.dart';
import 'package:front_end/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUsecase extends Usecase<String, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUsecase({required this.repository});

  @override
  Future<Either<Failure, String>> call(SendMessageParams params) async {
    return await repository.sendMessage(messageModel: params.messageModel);
  }
}

class SendMessageParams {
  final MessageModel messageModel;

  SendMessageParams({
    required this.messageModel,
  });
}
