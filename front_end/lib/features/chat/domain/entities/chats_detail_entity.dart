import 'package:equatable/equatable.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';

class ChatDetailEntity extends Equatable {
  final ChatsEntity chatsEntity;
  final List<SingleChatEntity> singleChatEntity;

  const ChatDetailEntity({
    required this.chatsEntity,
    required this.singleChatEntity,
  });

  @override
  List<Object?> get props => [
        chatsEntity,
        singleChatEntity,
      ];
}
