import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/service/socket_service.dart';
import 'package:front_end/features/chat/data/models/single_chat_model.dart';
import 'package:front_end/features/chat/domain/entities/list_chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/message_entity.dart';
import 'package:front_end/features/chat/domain/use_cases/fetch_messages_usecase.dart';
import 'package:front_end/features/chat/domain/use_cases/send_message_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessagesUsecase fetchMessagesUsecase;
  final SendMessageUsecase sendMessageUsecase;
  final SocketService _socketService = SocketService();
  final List<MessageEntity> _messages = [];
  final _storage = const FlutterSecureStorage();
  ListChatsEntity? _chatList;

  ChatBloc(
      {
      required this.fetchMessagesUsecase,
      required this.sendMessageUsecase})
      : super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendChatEvent>(_onSendChat);
    on<ReceiveChatEvent>(_onReceiveChat);
  }


  void _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());

    final failureOrGet =
        await fetchMessagesUsecase(FetchMessagesUsecaseParams(chatId: event.chatId));

    return failureOrGet.fold(
        (failure) => emit(ChatErrorState(errorMessage: failure.toString())),
        (chats) {
          _messages.clear();
          _messages.addAll(chats);
          emit(ChatLoadedState(messages: chats));
          _socketService.socket.emit('joinChat', event.chatId);

          _socketService.socket.on("newMessage", (data) => {
            print("step 1 - revieve $data"),
            add(ReceiveChatEvent(message: MessageEntity(
      message: data["message"],
      receiverId: data["receiverId"],
      senderId: data["senderId"],
      timestamp: DateTime.parse(data["timestamp"]),
      chatId: event.chatId,
      isRead: false
    )))
          });

        });
  }

  void _onSendChat(SendChatEvent event, Emitter<ChatState> emit) async {
    final userCredential = await _storage.read(key: "user_profile") ?? '';
    final body = await json.decode(userCredential);
    String userId = body["_id"].toString();


    final newMessage = {
      'chatId': event.messageModel.chatId,
      'senderId': userId,
      'receiverId': event.messageModel.receiverId,
      'timestamp': event.messageModel.timestamp.toIso8601String(),
      'message': event.messageModel.message,
      'isRead': false
    };
     
    _socketService.socket.emit('sendMessage', newMessage);
    emit(ChatLoadedState(messages: List.from(_messages)));
  }

  void _onReceiveChat(ReceiveChatEvent event, Emitter<ChatState> emit) async {
     print("step 1 - revieve event called");
     print(event.message);

     final message = MessageEntity(
       chatId: event.message.chatId,
       message: event.message.message,
       receiverId: event.message.receiverId,
       senderId: event.message.senderId,
       timestamp: event.message.timestamp,
       isRead: event.message.isRead
     );
     _messages.add(message);
     emit(ChatLoadedState(messages: List.from(_messages)));
  }
}
