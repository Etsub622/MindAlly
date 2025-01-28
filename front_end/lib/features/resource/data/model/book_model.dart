import 'package:front_end/features/resource/domain/entity/book_entity.dart';

class BookModel extends BookEntity {
  BookModel({
    required super.id,
    required super.title,
    required super.author,
    required super.image,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'title': super.title,
      'author': super.author,
      'image': super.image,
    };
  }

  BookEntity toEntity() {
    return BookEntity(
      id: super.id,
      title: super.title,
      author: super.author,
      image: super.image,
    );
  }
}
