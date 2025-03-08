

import 'package:front_end/features/chat/domain/entities/chats_detail_entity.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';

class ChatDetailsModel extends ChatDetailEntity {
  const ChatDetailsModel({
    required super.chatsEntity,
    required super.singleChatEntity,
  });

  factory ChatDetailsModel.fromJson(Map<String, dynamic> json) {
    return ChatDetailsModel(
      chatsEntity: json['chatsEntity'],
      singleChatEntity: json['singleChatEntity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatsEntity': chatsEntity,
      'singleChatEntity': singleChatEntity,
    };
  }

  ChatDetailsModel copyWith({
    ChatsEntity? chatsEntity,
    List<SingleChatEntity>? singleChatEntity,
  }) {
    return ChatDetailsModel(
      chatsEntity: chatsEntity ?? this.chatsEntity,
      singleChatEntity: singleChatEntity ?? this.singleChatEntity,
    );
  }
}
