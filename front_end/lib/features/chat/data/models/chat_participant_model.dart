
import 'package:front_end/features/chat/domain/entities/chat_participant_entity.dart';

class ChatParticipantModel extends ChatParticipantEntity {
  const ChatParticipantModel({
    required super.participantId,
    required super.participantName,
    required super.participantImageUrl,
  });

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChatParticipantModel(
      participantId: json['participantId'],
      participantName: json['participantName'],
      participantImageUrl: json['participantImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'participantName': participantName,
      'participantImageUrl': participantImageUrl,
    };
  }

  ChatParticipantModel copyWith({
    String? participantId,
    String? participantName,
    String? participantImageUrl,
  }) {
    return ChatParticipantModel(
      participantId: participantId ?? this.participantId,
      participantName: participantName ?? this.participantName,
      participantImageUrl: participantImageUrl ?? this.participantImageUrl,
    );
  }
}
