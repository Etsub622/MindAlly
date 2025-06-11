import 'package:front_end/features/resource/domain/entity/video_entity.dart';

class VideoModel extends VideoEntity {
  VideoModel({
    required super.id,
    required super.title,
    required super.link,
    required super.profilePicture,
    required super.name,
    required super.image,
    required super.type,
    required super.categories,
    required super.ownerId,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      type: json['type'] ?? 'Video',
      ownerId: json['ownerId'] ?? '',
      categories: List<String>.from(json['categories'] as List<dynamic>) ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': super.title,
      'link': super.link,
      'profilePicture': super.profilePicture,
      'name': super.name,
      'image': super.image,
      'type': super.type,
      'categories': super.categories,
      'ownerId': super.ownerId,
    };
  }

  VideoEntity toEntity() {
    return VideoEntity(
      id: super.id,
      title: super.title,
      link: super.link,
      profilePicture: super.profilePicture,
      name: super.name,
      image: super.image,
      type: super.type,
      categories: super.categories,
      ownerId: super.ownerId,
    );
  }
}
