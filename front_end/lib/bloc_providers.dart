import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/injection_container.dart';

class MultiBLOCProvider {
  static final blocProvider = [
    BlocProvider<AuthBloc>(
      create: (_) => serviceLocator<AuthBloc>(),
    ),
  ];
}