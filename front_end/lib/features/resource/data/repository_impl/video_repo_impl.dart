import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/resource/data/datasource/remote_datasource/video_remote_datasource.dart';
import 'package:front_end/features/resource/data/model/video_model.dart';
import 'package:front_end/features/resource/domain/entity/video_entity.dart';
import 'package:front_end/features/resource/domain/repository/video_repository.dart';

class VideoRepoImpl implements VideoRepository {
  final VideoRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  VideoRepoImpl(this.networkInfo, this.remoteDatasource);

  @override
  Future<Either<Failure, String>> addVideo(VideoEntity video) async {
    if (await networkInfo.isConnected) {
      try {
        final newVideo = VideoModel(
            id: video.id,
            title: video.title,
            link: video.link,
            profilePicture: video.profilePicture,
            name: video.name,
            image: video.image);
        final res = await remoteDatasource.addVideo(newVideo);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'you are not connected to the internet'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteVideo(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.deleteVideo(id);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'you are not connected to the internet'));
    }
  }

  @override
  Future<Either<Failure, List<VideoEntity>>> getVideos() async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.getVideos();
        final videoEntities = res.map((video) => video.toEntity()).toList();
        return Right(videoEntities);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'you are not connected to the internet'));
    }
  }

  @override
  Future<Either<Failure, List<VideoEntity>>> searchVideo(String title) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.searchVideos(title);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'you are not connected to the internet'));
    }
  }

  @override
  Future<Either<Failure, String>> updateVideo(
      VideoEntity video, String id) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedVideo = VideoModel(
            id: video.id,
            title: video.title,
            link: video.link,
            profilePicture: video.profilePicture,
            name: video.name,
            image: video.image);
        final res = await remoteDatasource.updateVideo(updatedVideo, id);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'you are not connected to the internet'));
    }
  }
}
