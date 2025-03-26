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
     _initializeSocketListener();
  }

  Future<void> _initializeSocketListener() async {
    await _socketService.initSocket(); // Wait for initialization
    _socketService.socket.on("newMessage", (data) {
      final message = MessageEntity(
        message: data["message"],
        receiverId: data["receiverId"],
        senderId: data["senderId"],
        timestamp: DateTime.parse(data["timestamp"]),
        chatId: data["chatId"],
        isRead: data["isRead"] ?? false,
      );
      add(ReceiveChatEvent(message: message));
    });
  }

  void _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
     
     if(event.chatId == null || event.chatId == ""){
      emit(ChatLoadedState(messages: []));
     }
     else{
      
    
    final failureOrGet =
        await fetchMessagesUsecase(FetchMessagesUsecaseParams(chatId: event.chatId));

    return failureOrGet.fold(
        (failure) => emit(ChatErrorState(errorMessage: failure.toString())),
        (chats) {
          _messages.clear();
          _messages.addAll(chats);
          emit(ChatLoadedState(messages: chats));
          _socketService.socket.emit('joinChat', event.chatId);

          // _socketService.socket.on("newMessage", (data) => {
          //   add(ReceiveChatEvent(message: MessageEntity(
          //   message: data["message"],
          //   receiverId: data["receiverId"],
          //   senderId: data["senderId"],
          //   timestamp: DateTime.parse(data["timestamp"]),
          //   chatId: data["chatId"],
          //   isRead: false
          // )))
          // });

        });
     }
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
     
     if(event.messageModel.chatId == null || event.messageModel.chatId == ""){

    final failureOrChatId = await sendMessageUsecase(SendMessageParams(messageModel: event.messageModel));
    failureOrChatId.fold(
      (failure) => emit(ChatErrorState(errorMessage: failure.toString())),
      (chatId) {
        // If it's a new chat, trigger loading messages with the new chatId
        if (event.messageModel.chatId == null || event.messageModel.chatId == "") {
          add(LoadMessagesEvent(chatId: chatId));
        } else {
          emit(ChatLoadedState(messages: List.from(_messages)));
        }
      },
    );
     }else{
      _socketService.socket.emit('sendMessage', newMessage);
     }
  }

  void _onReceiveChat(ReceiveChatEvent event, Emitter<ChatState> emit) async {
     print("step 1 - revieve event called");
     print(event.message);
     print(_messages);
     _messages.add(event.message);
     emit(ChatLoadedState(messages: List.from(_messages)));
  }
}
