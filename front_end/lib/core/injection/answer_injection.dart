import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/Q&A/data/datasource/answer_remote_datasource.dart';
import 'package:front_end/features/Q&A/data/repositoty_impl/answer_repo_impl.dart';
import 'package:front_end/features/Q&A/domain/repository/answer_repository.dart';
import 'package:front_end/features/Q&A/domain/usecase/answer_usecase.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:http/http.dart' as http;

class AnswerInjection {
  init() {
    print('ArticleInjection initialized');

    // Bloc
    sl.registerFactory(() => AnswerBloc(
          addAnswerUsecase: sl(),
          deleteAnswerUsecase: sl(),
          updateAnswerUsecase: sl(),
          getAnswersUsecase: sl(),
        ));

    // Usecases
    sl.registerLazySingleton(() => GetAnswersUsecase(sl()));
    sl.registerLazySingleton(() => AddAnswerUsecase(sl()));
    sl.registerLazySingleton(() => DeleteAnswerUsecase(sl()));
    sl.registerLazySingleton(() => UpdateAnswerUsecase(sl()));

    // Repository
    sl.registerLazySingleton<AnswerRepository>(
        () => AnswerRepoImpl(sl(), sl()));

    // Data Source
    sl.registerLazySingleton<AnswerRemoteDatasource>(
        () => AnswerRemoteDataSourceImpl(sl<http.Client>()));
  }
}
