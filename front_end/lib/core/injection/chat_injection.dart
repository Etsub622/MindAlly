import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:front_end/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:front_end/features/chat/domain/repositories/chat_repository.dart';
import 'package:front_end/features/chat/domain/use_cases/get_all_chats_usecase.dart';
import 'package:front_end/features/chat/domain/use_cases/fetch_messages_usecase.dart';
import 'package:front_end/features/chat/domain/use_cases/send_message_usecase.dart';
import 'package:front_end/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';

class ChatInjection {
  init() {
    // Bloc
    // Use cases
  sl.registerLazySingleton(
      () => FetchMessagesUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => SendMessageUsecase(repository: sl()));
  sl.registerLazySingleton(
      () => GetAllChatUsecase(repository: sl()));

  // DataSource
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl());

  // repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Bloc
  sl.registerFactory(() => ChatBloc(
      fetchMessagesUsecase: sl(),
      sendMessageUsecase: sl()));

  sl.registerFactory(() => ChatListBloc(
      getAllChatUsecase: sl()));

  }
}
