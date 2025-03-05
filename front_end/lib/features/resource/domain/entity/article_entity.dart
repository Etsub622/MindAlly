import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String link;
  final String logo;
  final String type;
  final List<String> categories;

  ArticleEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.link,
    required this.logo,
    required this.type,
    required this.categories,
  });
  @override
  List<Object> get props {
    return [
      id,
      title,
      content,
      link,
      logo,
      type,
      categories,
    ];
  }
}
