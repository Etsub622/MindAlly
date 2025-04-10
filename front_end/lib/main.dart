import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front_end/bloc_providers.dart';
import 'package:front_end/core/injection/injections.dart' as di;
import 'package:front_end/core/service/push_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize other dependencies
  await di.init();

  runApp(
    MultiBlocProvider(
      providers: MultiBLOCProvider.blocProvider,
      child: const NotificationWrapper(),
    ),
  );
}
