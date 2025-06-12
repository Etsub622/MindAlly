import 'package:front_end/features/resource/domain/entity/article_entity.dart';

class ArticleModel extends ArticleEntity {
  ArticleModel(
      {required super.id,
      required super.title,
      required super.content,
      required super.link,
      required super.logo,
      required super.type,
      required super.ownerId,
      required super.categories});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      link: json['link'] ?? '',
      logo: json['logo'] ?? '',
      type: json['type'] ?? '',
      ownerId: json['ownerId'] ?? '',
      categories: List<String>.from(json['categories'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': super.title,
      'content': super.content,
      'link': super.link,
      'logo': super.logo,
      'type': super.type,
      'ownerId': super.ownerId,
      'categories': super.categories,
    };
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
        id: super.id,
        title: super.title,
        content: super.content,
        link: super.link,
        logo: super.logo,
        type: super.type,
        ownerId: super.ownerId,
        categories: super.categories);
  }
}
