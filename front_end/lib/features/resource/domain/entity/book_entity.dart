import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String id;
  final String image;
  final String author;
  final String title;
  BookEntity(
      {required this.id,
      required this.image,
      required this.author,
      required this.title});
  @override
  List<Object> get props {
    return [
      id,
      image,
      author,
      title,
    ];
  }
  

}
