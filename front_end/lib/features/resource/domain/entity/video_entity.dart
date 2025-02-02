import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final String id;
  final String image;
  final String title;
  final String link;
  final String profilePicture;
  final String name;
  VideoEntity(
      {required this.id,
      required this.image,
      required this.title,
      required this.link,
      required this.profilePicture,
      required this.name});
  @override
  List<Object> get props {
    return [
      id,
      image,
      title,
      link,
      profilePicture,
      name,
    ];
  }
}
