import 'package:front_end/features/resource/domain/entity/book_entity.dart';

class BookModel extends BookEntity {
  BookModel({
    required super.title,
    required super.author,
    required super.image,
    required super.type,
    required super.id,
    required super.categories,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'],
      author: json['author'],
      image: json['image'],
      type: json['type'],
      id: json['_id'],
      categories: List<String>.from(json['categories'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': super.title,
      'author': super.author,
      'image': super.image,
      'type': super.type,
      'categories': super.categories,
    };
  }

  BookEntity toEntity() {
    return BookEntity(
      id: super.id,
      title: super.title,
      author: super.author,
      image: super.image,
      type: super.type,
      categories: super.categories,
    );
  }
}
