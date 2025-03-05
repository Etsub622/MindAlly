
import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/resource/data/datasource/remote_datasource/article_remote_datasource.dart';
import 'package:front_end/features/resource/data/repository_impl/article_repo_impl.dart';
import 'package:front_end/features/resource/domain/repository/article_repository.dart';
import 'package:front_end/features/resource/domain/usecase/article_usecase.dart';
import 'package:front_end/features/resource/presentation/bloc/article_bloc/bloc/article_bloc.dart';
import 'package:http/http.dart' as http;

class ArticleInjection {
  void init() {
    print('ArticleInjection initialized');
    try {
      // Data Source
      sl.registerLazySingleton<ArticleRemoteDatasource>(
        () => ArticleRemoteDataSourceImpl(sl<http.Client>()),
      );

      // Repository
      sl.registerLazySingleton<ArticleRepository>(
        () => ArticleRepoImpl(
          sl<NetworkInfo>(),
          sl<ArticleRemoteDatasource>(),
        ),
      );

      // Use Cases
      sl.registerLazySingleton<GetArticlesUsecase>(
        () => GetArticlesUsecase(sl<ArticleRepository>()),
      );
      sl.registerLazySingleton<AddArticleUsecase>(
        () => AddArticleUsecase(sl<ArticleRepository>()),
      );
      sl.registerLazySingleton<DeleteArticleUsecase>(
        () => DeleteArticleUsecase(sl<ArticleRepository>()),
      );
      sl.registerLazySingleton<UpdateArticleUsecase>(
        () => UpdateArticleUsecase(sl<ArticleRepository>()),
      );
      sl.registerLazySingleton<SearchArticleUsecase>(
        () => SearchArticleUsecase(sl<ArticleRepository>()),
      );

      // Bloc
      sl.registerFactory<ArticleBloc>(
        () => ArticleBloc(
          getArticlesUsecase: sl<GetArticlesUsecase>(),
          addArticleUsecase: sl<AddArticleUsecase>(),
          deleteArticleUsecase: sl<DeleteArticleUsecase>(),
          updateArticleUsecase: sl<UpdateArticleUsecase>(),
          searchArticleUsecase: sl<SearchArticleUsecase>(),
        ),
      );

      print("Article dependencies registered successfully");
    } catch (e) {
      print("Error registering article dependencies: $e");
      rethrow; // Optional: for debugging
    }
  }
}
