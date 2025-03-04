
import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String studentName;
  final String studentProfile;
  final String category;
  QuestionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.studentName,
    required this.studentProfile,
    required this.category,
  });
  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      studentName,
      studentProfile,
      category,

    ];
  }
}
