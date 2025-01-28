import 'package:front_end/features/resource/domain/entity/video_entity.dart';

class VideoModel extends VideoEntity {
  VideoModel({
    required super.id,
    required super.title,
    required super.link,
    required super.profilePicture,
    required super.name,
    required super.image,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'],
      link: json['link'],
      profilePicture: json['profilePicture'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'title': super.title,
      'link': super.link,
      'profilePicture': super.profilePicture,
      'name': super.name,
      'image': super.image,
    };
  }

  // VideoEntity toEntity() {
  //   return VideoEntity(
  //     id: super.id,
  //     title: super.title,
  //     link: super.link,
  //     profilePicture: super.profilePicture,
  //     name: super.name,
  //     image: super.image,
  //   );
  // }
}
