

import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/mock_data/chat_data.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage(
      {required String message,
      required String senderId,
      required String receiverId,
      required String chatId});

  Future<List<SingleChatEntity>> getSingleChat({
    required String chatId,
  });

  Future<List<ChatsEntity>> getAllChats({
    required String senderId,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<List<ChatsEntity>> getAllChats({required String senderId}) async {
    try {
      List<ChatsEntity> allChats = ChatsList.chats;
      return allChats;
    } catch (e) {
      throw ServerException(
        message: 'Error in getting all chats',
      );
    }
  }

  @override
  Future<List<SingleChatEntity>> getSingleChat({required String chatId}) async {
    try {
      List<SingleChatEntity> singleChat = ChatDetailList.chatSamples;
      return singleChat;
    } catch (e) {
      throw ServerException(
        message: 'Error in getting single chat',
      );
    }
  }

  @override
  Future<void> sendMessage(
      {required String message,
      required String chatId,
      required String senderId,
      required String receiverId}) async {
    try {
      return;
    } catch (e) {
      throw ServerException(
        message: 'Error in sending message',
      );
    }
  }
}
