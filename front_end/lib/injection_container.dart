import 'package:front_end/core/routes/router_config.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';


final serviceLocator = GetIt.instance;

Future<void> init() async {

  serviceLocator.registerSingleton<GoRouter>(routerConfig());
}
