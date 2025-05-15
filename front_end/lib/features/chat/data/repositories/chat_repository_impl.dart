import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:front_end/features/chat/data/models/single_chat_model.dart';
import 'package:front_end/features/chat/domain/entities/list_chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/message_entity.dart';
import 'package:front_end/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, ListChatsEntity>> getAllChats() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllChats();
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ServerFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> fetchMessages(
      {required String? chatId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.fetchMessages(chatId: chatId);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(ServerFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, String>> sendMessage(
      {required MessageModel messageModel}) async {
    // if (await networkInfo.isConnected) {
      try {
        final chatId = await remoteDataSource.sendMessage(messageModel: messageModel);
        
        return  Right(chatId);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    // } else {
    //   return Left(ServerFailure(message: "No Internet Connection"));
    // }
  }
}
