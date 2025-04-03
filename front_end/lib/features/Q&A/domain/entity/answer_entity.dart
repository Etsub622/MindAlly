import 'package:equatable/equatable.dart';

class AnswerEntity extends Equatable {
  final String id;
  final String answer;
  final String therapistName;
  final String therapistProfile;
  final String questionId;
  AnswerEntity({
    required this.id,
    required this.answer,
    required this.therapistName,
    required this.therapistProfile,
    required this.questionId,
  });

  @override
  List<Object?> get props {
    return [id, answer, therapistName, therapistProfile, questionId];
  }
}
