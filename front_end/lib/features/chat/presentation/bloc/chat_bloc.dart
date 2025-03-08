import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';
import 'package:front_end/features/chat/domain/use_cases/get_all_chats_usecase.dart';
import 'package:front_end/features/chat/domain/use_cases/get_single_chat_usecase.dart';
import 'package:front_end/features/chat/domain/use_cases/send_message_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllChatUsecase getAllChatUsecase;
  final GetSingleChatUsecase getSingleChatUsecase;
  final SendMessageUsecase sendMessageUsecase;

  ChatBloc(
      {required this.getAllChatUsecase,
      required this.getSingleChatUsecase,
      required this.sendMessageUsecase})
      : super(ChatInitial()) {
    on<GetAllChatsEvent>(_getAllChat);
    on<GetSingleChatEvent>(_getSingleChat);
    on<SendChatEvent>(_sendChat);
  }

  void _getAllChat(GetAllChatsEvent event, Emitter<ChatState> emit) async {
    emit(GetAllChatsState(status: ChatStatus.loading));

    final failureOrGet =
        await getAllChatUsecase(GetAllChatParams(senderId: event.userId));

    return failureOrGet.fold(
        (failure) => emit(GetAllChatsState(status: ChatStatus.error)),
        (chats) =>
            emit(GetAllChatsState(status: ChatStatus.success, chats: chats)));
  }

  void _getSingleChat(GetSingleChatEvent event, Emitter<ChatState> emit) async {
    emit(GetSingleChatState(status: ChatStatus.loading));

    final failureOrGet =
        await getSingleChatUsecase(GetSingleChatParams(chatId: event.chatId));

    return failureOrGet.fold(
        (failure) => emit(GetSingleChatState(status: ChatStatus.error)),
        (chats) =>
            emit(GetSingleChatState(status: ChatStatus.success, chats: chats)));
  }

  void _sendChat(SendChatEvent event, Emitter<ChatState> emit) async {
    emit(SendChatState(status: ChatStatus.loading));

    final failureOrGet = await sendMessageUsecase(SendMessageParams(
        message: event.message,
        senderId: event.senderId,
        receiverId: event.receiverId,
        chatId: event.chatId));

    return failureOrGet.fold(
        (failure) => emit(GetSingleChatState(status: ChatStatus.error)),
        (chats) => emit(GetSingleChatState(status: ChatStatus.success)));
  }
}
