import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/chat/domain/entities/message_entity.dart';
import 'package:front_end/features/chat/domain/repositories/chat_repository.dart';

class FetchMessagesUsecase extends Usecase<void, FetchMessagesUsecaseParams> {
  final ChatRepository repository;

  FetchMessagesUsecase({required this.repository});

  @override
  Future<Either<Failure, List<MessageEntity>>> call(
      FetchMessagesUsecaseParams params) async {
    return await repository.fetchMessages(
      chatId: params.chatId,
    );
  }
}

class FetchMessagesUsecaseParams {
  final String? chatId;

  FetchMessagesUsecaseParams({
    required this.chatId,
  });
}
