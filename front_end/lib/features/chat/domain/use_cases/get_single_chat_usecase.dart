import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';
import 'package:front_end/features/chat/domain/repositories/chat_repository.dart';

class GetSingleChatUsecase extends Usecase<void, GetSingleChatParams> {
  final ChatRepository repository;

  GetSingleChatUsecase({required this.repository});

  @override
  Future<Either<Failure, List<SingleChatEntity>>> call(
      GetSingleChatParams params) async {
    return await repository.getSingleChat(
      chatId: params.chatId,
    );
  }
}

class GetSingleChatParams {
  final String chatId;

  GetSingleChatParams({
    required this.chatId,
  });
}
