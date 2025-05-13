import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/calendar/presentation/bloc/add_event/add_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/delete_event/delete_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_events/get_events_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/get_single_event/get_event_bloc.dart';
import 'package:front_end/features/calendar/presentation/bloc/update_event/update_events_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/answer_bloc.dart';
import 'package:front_end/features/Q&A/presentation/bloc/bloc/question_bloc.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:front_end/features/resource/presentation/bloc/book_bloc/bloc/book_bloc.dart';
import 'package:front_end/features/resource/presentation/bloc/video_bloc/bloc/video_bloc.dart';
import 'package:front_end/features/resource/presentation/bloc/article_bloc/bloc/article_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/delete_patient_bloc/delete_patient_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/update_patient_bloc/update_patient_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/delete_therapist_bloc/delete_therapist_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/update_therapist_bloc/update_therapist_bloc.dart';
import 'package:front_end/features/Home/presentation/bloc/get_matched_therapists_bloc/get_matched_therapists_bloc.dart';

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
    BlocProvider<PatientProfileBloc>(create: (_) => sl<PatientProfileBloc>()),
    BlocProvider<TherapistProfileBloc>(
        create: (_) => sl<TherapistProfileBloc>()),
    BlocProvider<UpdatePatientBloc>(create: (_) => sl<UpdatePatientBloc>()),
    BlocProvider<UpdateTherapistBloc>(create: (_) => sl<UpdateTherapistBloc>()),
    BlocProvider<ChatBloc>(create: (_) => sl<ChatBloc>()),
    BlocProvider<ChatListBloc>(create: (_) => sl<ChatListBloc>()),
    BlocProvider<QuestionBloc>(create: (_) => sl<QuestionBloc>()),
    BlocProvider<AnswerBloc>(create: (_) => sl<AnswerBloc>()),
    BlocProvider<DeletePatientBloc>(
      create: (_) => sl<DeletePatientBloc>()
    ),
    BlocProvider<DeleteTherapistBloc>(
      create: (_) => sl<DeleteTherapistBloc>()
    ),

    BlocProvider<GetMatchedTherapistsBloc>(
      create: (_) => sl<GetMatchedTherapistsBloc>()
    ),

    BlocProvider<AddScheduledEventsBloc>(
      create: (_) => sl<AddScheduledEventsBloc>()
    ),
    BlocProvider<DeleteScheduledEventsBloc>(
      create: (_) => sl<DeleteScheduledEventsBloc>()
    ),
    BlocProvider<GetScheduledEventsBloc>(
      create: (_) => sl<GetScheduledEventsBloc>()
    ),
    BlocProvider<GetScheduledEventBloc>(
      create: (_) => sl<GetScheduledEventBloc>()
    ),
    BlocProvider<UpdateScheduledEventsBloc>(
      create: (_) => sl<UpdateScheduledEventsBloc>()
    ),

  ];
}
