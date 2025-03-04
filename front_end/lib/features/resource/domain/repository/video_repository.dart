import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/resource/domain/entity/video_entity.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<VideoEntity>>> getVideos();
  Future<Either<Failure, String>> addVideo(VideoEntity video);
  Future<Either<Failure, String>> updateVideo(VideoEntity video,String id);
  Future<Either<Failure, String>> deleteVideo(String id);
  Future<Either<Failure, List<VideoEntity>>>searchVideo(String title);
  Future<Either<Failure, VideoEntity>> getSingleVideo(String id);
  Future<Either<Failure, List<VideoEntity>>> getVideoByCategory(String category);
  
}