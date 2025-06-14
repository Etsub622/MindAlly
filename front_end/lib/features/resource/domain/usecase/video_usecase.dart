import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/resource/domain/entity/video_entity.dart';
import 'package:front_end/features/resource/domain/repository/video_repository.dart';


class GetVideosUSecase extends Usecase<List<VideoEntity>, NoParams> {
  final VideoRepository repository;

  GetVideosUSecase(this.repository);

  @override
  Future<Either<Failure, List<VideoEntity>>> call(NoParams params) async {
    return await repository.getVideos();
  }
}

class GetSingleVideoUsecase extends Usecase<VideoEntity, GetSingleVideoParams> {
  final VideoRepository repository;
  GetSingleVideoUsecase(this.repository);

  @override
  Future<Either<Failure, VideoEntity>> call(GetSingleVideoParams params) async {
    return await repository.getSingleVideo(params.id);
  }
}

class GetSingleVideoParams {
  final String id;
  GetSingleVideoParams(this.id);
}

class AddVideoUsecase extends Usecase<String, AddVideoParams> {
  final VideoRepository repository;
  AddVideoUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(AddVideoParams params) async {
    return await repository.addVideo(params.videoEntity);
  }
}

class AddVideoParams {
  final VideoEntity videoEntity;
  AddVideoParams(this.videoEntity);
}

class UpdateVideoUsecase extends Usecase<String, UPdateVideoParams> {
  final VideoRepository repository;
  UpdateVideoUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(UPdateVideoParams params) async {
    return await repository.updateVideo(params.updateEntity, params.id);
  }
}

class UPdateVideoParams {
  final VideoEntity updateEntity;
  final String id;
  UPdateVideoParams(this.updateEntity, this.id);
}

class DeleteVideoUsecase extends Usecase<String, DeleteVideoParams> {
  final VideoRepository repository;
  DeleteVideoUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteVideoParams params) async {
    return await repository.deleteVideo(params.id);
  }
}

class DeleteVideoParams {
  final String id;
  DeleteVideoParams(this.id);
}

class SearchVideoUsecase extends Usecase<List<VideoEntity>, SearchVideoParams> {
  final VideoRepository repository;
  SearchVideoUsecase(this.repository);

  @override
  Future<Either<Failure, List<VideoEntity>>> call(
      SearchVideoParams params) async {
    return await repository.searchVideo(params.title);
  }
}

class SearchVideoParams {
  final String title;
  SearchVideoParams(this.title);
}


class GetVideoByCategoryUsecase extends Usecase<List<VideoEntity>, GetVideoByCategoryParams> {
  final VideoRepository repository;
  GetVideoByCategoryUsecase(this.repository);

  @override
  Future<Either<Failure, List<VideoEntity>>> call(
      GetVideoByCategoryParams params) async {
    return await repository.getVideoByCategory(params.category);
  }
}

class GetVideoByCategoryParams {
  final String category;
  GetVideoByCategoryParams(this.category);
}