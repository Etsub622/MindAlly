import 'package:front_end/features/resource/data/datasource/remote_datasource/video_remote_datasource.dart';
import 'package:front_end/features/resource/data/repository_impl/video_repo_impl.dart';
import 'package:front_end/features/resource/domain/repository/video_repository.dart';
import 'package:front_end/features/resource/domain/usecase/video.dart';
import 'package:front_end/features/resource/presentation/bloc/video_bloc/bloc/video_bloc.dart';
import 'package:front_end/core/injection/injections.dart';

class VideoInjection {
  init() {
    // Bloc
    sl.registerFactory(() => VideoBloc(
          getVideosUsecase: sl(),
          addVideoUsecase: sl(),
          deleteVideoUsecase: sl(),
          updateVideoUsecase: sl(),
          searchVideoUsecase: sl(),
        ));

    // Usecase
    sl.registerLazySingleton(() => GetVideosUSecase(sl()));
    sl.registerLazySingleton(() => UpdateVideoUsecase(sl()));
    sl.registerLazySingleton(() => SearchVideoUsecase(sl()));
    sl.registerLazySingleton(() => DeleteVideoUsecase(sl()));
    sl.registerLazySingleton(() => AddVideoUsecase(sl()));

    // Repository
    sl.registerLazySingleton<VideoRepository>(() => VideoRepoImpl(sl(), sl()));

    // Data Source
    sl.registerLazySingleton<VideoRemoteDataSourceImpl>(
        () => VideoRemoteDataSourceImpl(sl()));
  }
}
