import 'package:front_end/features/Q&A/domain/entity/answer_entity.dart';

class AnswerModel extends AnswerEntity {
  AnswerModel({
    required super.id,
    required super.questionId,
    required super.answer,
    required super.therapistName,
    required super.therapistProfile,
  });
  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['_id'],
      questionId: json['questionId'],
      answer: json['answer'],
      therapistName: json['therapistName'],
      therapistProfile: json['therapistProfile'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'questionId': super.questionId,
      'answer': super.answer,
      'therapistName': super.therapistName,
      'therapistProfile': super.therapistProfile,
    };
  }
  AnswerEntity toEntity() {
    return AnswerEntity(
      id: super.id,
      questionId: super.questionId,
      answer: super.answer,
      therapistName: super.therapistName,
      therapistProfile: super.therapistProfile,
    );
  }
}
