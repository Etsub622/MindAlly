import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/injection/answer_injection.dart';
import 'package:front_end/core/injection/article_injection.dart';
import 'package:front_end/core/injection/auth_injection.dart';
import 'package:front_end/core/injection/book_injection.dart';
import 'package:front_end/core/injection/chat_injection.dart';
import 'package:front_end/core/injection/home_injection.dart';
import 'package:front_end/core/injection/profile_injection.dart';
import 'package:front_end/core/injection/question_injection.dart';
import 'package:front_end/core/injection/video_injection.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../network/network.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnection());
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  final sharedPref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPref);

  AuthInjection().init();
  BookInjection().init();
  ArticleInjection().init();
  VideoInjection().init();
  ProfileInjection().init();
  ChatInjection().init();
  QuestionInjection().init();
  AnswerInjection().init(); 
  HomeInjection().init();
}
