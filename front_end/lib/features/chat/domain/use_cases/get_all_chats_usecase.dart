import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/chat/domain/entities/list_chats_entity.dart';
import 'package:front_end/features/chat/domain/repositories/chat_repository.dart';

class GetAllChatUsecase extends Usecase<ListChatsEntity, NoParams> {
  final ChatRepository repository;

  GetAllChatUsecase({required this.repository});

  @override
  Future<Either<Failure, ListChatsEntity>> call(NoParams params) async {
    return await repository.getAllChats();
  }
}

