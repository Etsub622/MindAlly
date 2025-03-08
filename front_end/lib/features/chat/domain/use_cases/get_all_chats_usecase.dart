import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/repositories/chat_repository.dart';

class GetAllChatUsecase extends Usecase<void, GetAllChatParams> {
  final ChatRepository repository;

  GetAllChatUsecase({required this.repository});

  @override
  Future<Either<Failure, List<ChatsEntity>>> call(
      GetAllChatParams params) async {
    return await repository.getAllChats(
      senderId: params.senderId,
    );
  }
}

class GetAllChatParams {
  final String senderId;

  GetAllChatParams({
    required this.senderId,
  });
}
