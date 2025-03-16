import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/service/socket_service.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/chat/data/models/single_chat_model.dart';
import 'package:front_end/features/chat/domain/entities/list_chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/message_entity.dart';
import 'package:front_end/features/chat/domain/use_cases/get_all_chats_usecase.dart';
import 'package:front_end/features/chat/domain/use_cases/fetch_messages_usecase.dart';
import 'package:front_end/features/chat/domain/use_cases/send_message_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetAllChatUsecase getAllChatUsecase;
  ListChatsEntity? _chatList;

  ChatListBloc(
      {required this.getAllChatUsecase,
      })
      : super(ChatListInitial()) {
    on<GetAllChatsEvent>(_getAllChat);
  }

  void _getAllChat(GetAllChatsEvent event, Emitter<ChatListState> emit) async {
    emit(GetAllChatsState(status: ChatStatus.loading, chats: ListChatsEntity(chats: [], userId: '')));

    final failureOrGet =
        await getAllChatUsecase(NoParams());

    return failureOrGet.fold(
        (failure) => emit(GetAllChatsState(status: ChatStatus.error, chats: ListChatsEntity(chats: [], userId: ''))),
        (chats) {
            _chatList = chats;
            emit(GetAllChatsState(status: ChatStatus.success, chats: chats));
            });
  }

}