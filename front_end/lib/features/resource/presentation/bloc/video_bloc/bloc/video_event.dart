part of 'video_bloc.dart';

@immutable
sealed class VideoEvent {
  const VideoEvent();
}

class AddVideoEvent extends VideoEvent {
  final VideoEntity videoEntity;
  AddVideoEvent(this.videoEntity);
}


class GetVideoEvent extends VideoEvent {
  const GetVideoEvent();
}
class GetSingleVideoEvent extends VideoEvent {
  final String id;
  GetSingleVideoEvent(this.id);
}

class UpdateVideoEvent extends VideoEvent {
  final VideoEntity videoEntity;
  final String id;
  UpdateVideoEvent(this.videoEntity, this.id);
}

class DeleteVideoEvent extends VideoEvent {
  final String id;
  DeleteVideoEvent(this.id);
}

class SearchVideoEvent extends VideoEvent {
  final String title;
  SearchVideoEvent(this.title);
}

class SearchVideoByCategoryEvent extends VideoEvent {
  final String category;
  SearchVideoByCategoryEvent(this.category);
}
