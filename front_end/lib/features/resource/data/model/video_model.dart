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
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id'],
      title: json['title'],
      link: json['link'],
      profilePicture: json['profilePicture'],
      name: json['name'],
      image: json['image'],
      type: json['type'],
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
    );
  }
}
