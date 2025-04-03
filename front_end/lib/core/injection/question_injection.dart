import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/Q&A/data/datasource/question_remote_datasource.dart';
import 'package:front_end/features/Q&A/data/repositoty_impl/question_repo_impl.dart';
import 'package:front_end/features/Q&A/domain/repository/question_repository.dart';
import 'package:front_end/features/Q&A/domain/usecase/question_usecase.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/question_bloc.dart';
import 'package:http/http.dart' as http;



class QuestionInjection {
  init() {
    print('ArticleInjection initialized');

    // Bloc
    sl.registerFactory(() => QuestionBloc(
          getQuestionByCategoryUsecase: sl(),
          createQuestionUsecase: sl(),
          deleteQuestionUsecase: sl(),
          updateQuestionUsecase: sl(),
          getQuestionsUsecase: sl(),
        ));

    // Usecases
    sl.registerLazySingleton(() => GetQuestionsUsecase(sl()));
    sl.registerLazySingleton(() => CreateQuestionUsecase(sl()));
    sl.registerLazySingleton(() => DeleteQuestionUsecase(sl()));
    sl.registerLazySingleton(() => UpdateQuestionUsecase(sl()));
    sl.registerLazySingleton(() => GetQuestionByCatetoryUsecase(sl()));
  

    // Repository
    sl.registerLazySingleton<QuestionRepository>(
        () => QuestionRepoImpl(sl(), sl()));

    // Data Source
    sl.registerLazySingleton<QuestionRemoteDatasource>(
        () => QuestionRemoteDataSourceImpl(sl<http.Client>()));
  }
}
