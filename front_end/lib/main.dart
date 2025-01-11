import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'package:front_end/core/routes/router_config.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(
    AppRouter(
    router: serviceLocator<GoRouter>(),
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

}

  @override
  Widget build(BuildContext context) {
    return AppRouter(
      router: serviceLocator(),
    );
  }
}