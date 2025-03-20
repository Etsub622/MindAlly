import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/update_patient_bloc/update_patient_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/update_therapist_bloc/update_therapist_bloc.dart';
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
      create:(_)=>sl<ArticleBloc>(),
    ),

    BlocProvider<PatientProfileBloc>(
      create: (_) => sl<PatientProfileBloc>()
      ),
    BlocProvider<TherapistProfileBloc>(
      create: (_) => sl<TherapistProfileBloc>()
      ),
    BlocProvider<UpdatePatientBloc>(
      create: (_) => sl<UpdatePatientBloc>()
      ),
    BlocProvider<UpdateTherapistBloc>(
      create: (_) => sl<UpdateTherapistBloc>()
      ),

    BlocProvider<ChatBloc>(
      create: (_) => sl<ChatBloc>()
    ),
    BlocProvider<ChatListBloc>(
      create: (_) => sl<ChatListBloc>()
    )

  ];
}