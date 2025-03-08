import 'package:equatable/equatable.dart';

class ChatParticipantEntity extends Equatable {
  final String participantId;
  final String participantName;
  final String participantImageUrl;

  const ChatParticipantEntity({
    required this.participantId,
    required this.participantName,
    required this.participantImageUrl,
  });

  @override
  List<Object?> get props =>
      [participantId, participantName, participantImageUrl];
}
