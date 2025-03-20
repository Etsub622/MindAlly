import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/question_bloc.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:front_end/features/profile/presentation/bloc/user_profile_bloc.dart';
import 'package:front_end/features/resource/presentation/bloc/article_bloc/bloc/article_bloc.dart';
import 'package:front_end/features/resource/presentation/bloc/book_bloc/bloc/book_bloc.dart';
import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/resource/presentation/bloc/video_bloc/bloc/video_bloc.dart';

class MultiBLOCProvider {
  static final blocProvider = [
    BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
    ),
    BlocProvider<BookBloc>(
      create: (_) => sl<BookBloc>(),
    ),
    BlocProvider<VideoBloc>(
      create: (_) => sl<VideoBloc>(),
    ),
    BlocProvider<ArticleBloc>(
      create: (_) => sl<ArticleBloc>(),
    ),
    BlocProvider<UserProfileBloc>(create: (_) => sl<UserProfileBloc>()),
    BlocProvider<ChatBloc>(create: (_) => sl<ChatBloc>()),
    BlocProvider<ChatListBloc>(create: (_) => sl<ChatListBloc>()),
    BlocProvider<ChatBloc>(create: (_) => sl<ChatBloc>()),
    BlocProvider<QuestionBloc>(create: (_) => sl<QuestionBloc>()),
    BlocProvider<AnswerBloc>(create: (_) => sl<AnswerBloc>()),
  ];
}
