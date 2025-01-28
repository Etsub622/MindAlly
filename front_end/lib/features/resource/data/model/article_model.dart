import 'package:front_end/features/resource/domain/entity/article_entity.dart';

class ArticleModel extends ArticleEntity {
  ArticleModel(
      {required super.id,
      required super.title,
      required super.content,
      required super.link,
      required super.logo});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      link: json['link'],
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'title': super.title,
      'content': super.content,
      'link': super.link,
      'logo': super.logo,
    };
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
        id: super.id,
        title: super.title,
        content: super.content,
        link: super.link,
        logo: super.logo);
  }
}
