part of 'video_bloc.dart';

@immutable
sealed class VideoState {}

final class VideoInitial extends VideoState {}
class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<VideoEntity> videos;
  VideoLoaded(this.videos);
}

class VideoError extends VideoState {
  final String message;
  VideoError(this.message);
}

class VideoAdded extends VideoState {
  final String message;
  VideoAdded(this.message);
}

class VideoUpdated extends VideoState {
  final String message;
  VideoUpdated(this.message);
}

class VideoDeleted extends VideoState {
  final String message;
  VideoDeleted(this.message);
}
class SearchFailed extends VideoState {
  final String message;
  SearchFailed(this.message);
}

class SingleVideoLoaded extends VideoState {
  final VideoEntity video;
  SingleVideoLoaded(this.video);
}
