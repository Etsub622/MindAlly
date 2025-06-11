import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/resource/data/datasource/remote_datasource/book_remote_datasource.dart';
import 'package:front_end/features/resource/data/repository_impl/book_repo_impl.dart';
import 'package:front_end/features/resource/domain/repository/book_repository.dart';
import 'package:front_end/features/resource/domain/usecase/book_usecase.dart';
import 'package:front_end/features/resource/presentation/bloc/book_bloc/bloc/book_bloc.dart';

class BookInjection {
  init() {
    // Bloc
    sl.registerFactory(() => BookBloc(
          getBooksUsecase: sl(),
          addBookUsecase: sl(),
          deleteBookUsecase: sl(),
          updateBookUsecase: sl(),
          searchBookUsecase: sl(),
          getSingleBookUsecase: sl(),
          searchBookByCategoryUsecase: sl(),
        ));

    // Usecase
    sl.registerLazySingleton(() => GetBooksUsecase(sl()));
    sl.registerLazySingleton(() => AddBookUsecase(sl()));
    sl.registerLazySingleton(() => DeleteBookUsecase(sl()));
    sl.registerLazySingleton(() => UpdateBookUsecase(sl()));
    sl.registerLazySingleton(() => SearchBookUsecase(sl()));
    sl.registerLazySingleton(() => GetSingleBookUsecase(sl()));
    sl.registerLazySingleton(() => SearchBookByCategoryUsecase(sl()));

    // Repository
    sl.registerLazySingleton<BookRepository>(() => BookRepoImpl(sl(), sl()));

    // Data Source
    sl.registerLazySingleton<BookRemoteDatasource>(
        () => BookRemoteDataSourceImpl(sl()));
  }
}
