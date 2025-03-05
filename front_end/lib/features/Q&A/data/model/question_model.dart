import 'package:front_end/features/Q&A/domain/entity/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.id,
    required super.title,
    required super.description,
    required super.studentName,
    required super.studentProfile,
    required super.category,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      studentName: json['studentName'],
      studentProfile: json['studentProfile'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'title': super.title,
      'description': super.description,
      'studentName': super.studentName,
      'studentProfile': super.studentProfile,
      'category': super.category,
    };
  }

  QuestionEntity toEntity() {
    return QuestionEntity(
      id: super.id,
      title: super.title,
      description: super.description,
      studentName: super.studentName,
      studentProfile: super.studentProfile,
      category: super.category,
    );
  }
}
