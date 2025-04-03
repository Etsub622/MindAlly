import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String id;
  final String image;
  final String author;
  final String title;
  final String type;
  final List<String> categories; 
  BookEntity({
    required this.id,
    required this.image,
    required this.author,
    required this.title,
    required this.type,
    required this.categories,
  });
  @override
  List<Object> get props {
    return [
      id,
      image,
      author,
      title,
      type,
      categories,
    ];
  }
}
