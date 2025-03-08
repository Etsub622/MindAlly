import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';
import 'package:front_end/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<ChatsEntity>>> getAllChats(
      {required String senderId}) async {
    // if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllChats(senderId: senderId);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    // } else {
    //   return Left(ServerFailure(message: "No Internet Connection"));
    // }
  }

  @override
  Future<Either<Failure, List<SingleChatEntity>>> getSingleChat(
      {required String chatId}) async {
    // if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSingleChat(chatId: chatId);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    // } else {
    //   return Left(ServerFailure(message: "No Internet Connection"));
    // }
  }

  @override
  Future<Either<Failure, void>> sendMessage(
      {required String message,
      required String senderId,
      required String chatId,
      required String receiverId}) async {
    // if (await networkInfo.isConnected) {
      try {
        remoteDataSource.sendMessage(
            message: message,
            senderId: senderId,
            receiverId: receiverId,
            chatId: chatId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    // } else {
    //   return Left(ServerFailure(message: "No Internet Connection"));
    // }
  }
}
