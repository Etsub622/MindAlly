import 'package:equatable/equatable.dart';

class AnswerEntity extends Equatable {
  final String id;
  final String answer;
  final String therapistName;
  final String therapistProfile;
  final String questionId;
  final String ownerId;
  AnswerEntity({
    required this.id,
    required this.answer,
    required this.therapistName,
    required this.therapistProfile,
    required this.questionId,
    required this.ownerId,  
  });

  @override
  List<Object?> get props {
    return [id, answer, therapistName, therapistProfile, questionId, ownerId];
  }
}
