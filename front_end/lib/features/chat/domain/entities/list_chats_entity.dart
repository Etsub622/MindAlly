import 'package:equatable/equatable.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';


class ListChatsEntity extends Equatable {
  final List<ChatsEntity> chats;
  final String userId;

  const ListChatsEntity({required this.chats, required this.userId});

  @override
  List<Object?> get props => [chats, userId];
}