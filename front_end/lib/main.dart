import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/bloc_providers.dart';
import 'package:front_end/core/routes/router_config.dart';
import 'package:front_end/core/injection/injections.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MultiBlocProvider(
      providers: MultiBLOCProvider.blocProvider, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppRouter(
      router: routerConfig(),
    );
  }
}
