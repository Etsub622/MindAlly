import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, void>> sendMessage(
      {required String message,
      required String chatId,
      required String senderId,
      required String receiverId});
  Future<Either<Failure, List<SingleChatEntity>>> getSingleChat(
      {required String chatId});
  Future<Either<Failure, List<ChatsEntity>>> getAllChats(
      {required String senderId});
}
