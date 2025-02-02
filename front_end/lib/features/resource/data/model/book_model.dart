import 'package:front_end/features/resource/domain/entity/book_entity.dart';

class BookModel extends BookEntity {
  BookModel({
    required super.title,
    required super.author,
    required super.image,
    required super.type,
    required super.id,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'],
      author: json['author'],
      image: json['image'],
      type: json['type'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': super.title,
      'author': super.author,
      'image': super.image,
      'type': super.type,
    };
  }

  BookEntity toEntity() {
    return BookEntity(
      id: super.id,
      title: super.title,
      author: super.author,
      image: super.image,
      type: super.type,
    );
  }
}
