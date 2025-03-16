import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/chat/data/models/single_chat_model.dart';
import 'package:front_end/features/chat/domain/entities/list_chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, void>> sendMessage({required MessageModel messageModel});
      
  Future<Either<Failure, List<MessageEntity>>> fetchMessages({required String chatId});

  Future<Either<Failure, ListChatsEntity>> getAllChats();
}
