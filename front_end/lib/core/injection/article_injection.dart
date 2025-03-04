import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/resource/data/datasource/remote_datasource/Article_remote_datasource.dart';
import 'package:front_end/features/resource/data/repository_impl/article_repo_impl.dart';
import 'package:front_end/features/resource/domain/repository/article_repository.dart';

import 'package:front_end/features/resource/presentation/bloc/article_bloc/bloc/article_bloc.dart';

import '../../features/resource/domain/usecase/article_usecase.dart';

class ArticleInjection {
  init() {
    print('ArticleInjection initialized');

    // Data Source 
    print('Registering ArticleRemoteDatasource...');
    sl.registerLazySingleton<ArticleRemoteDatasource>(
        () => ArticleRemoteDataSourceImpl(sl()));

    // Repository 
    print('Registering ArticleRepository...');
    sl.registerLazySingleton<ArticleRepository>(
        () => ArticleRepoImpl(sl(), sl()));

    // Usecases
    sl.registerLazySingleton(() => GetArticlesUsecase(sl()));
    sl.registerLazySingleton(() => AddArticleUsecase(sl()));
    sl.registerLazySingleton(() => DeleteArticleUsecase(sl()));
    sl.registerLazySingleton(() => UpdateArticleUsecase(sl()));
    sl.registerLazySingleton(() => SearchArticleUsecase(sl()));
    sl.registerLazySingleton(() => GetSingleArticleUsecase(sl()));

    // Bloc
    sl.registerFactory(() => ArticleBloc(
          getArticlesUsecase: sl(),
          addArticleUsecase: sl(),
          deleteArticleUsecase: sl(),
          updateArticleUsecase: sl(),
          searchArticleUsecase: sl(),
          getSingleArticleUsecase: sl(),
        ));
  }
}
