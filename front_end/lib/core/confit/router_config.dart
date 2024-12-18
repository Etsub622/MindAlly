import 'package:front_end/core/confit/app_path.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_one.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_three.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_two.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router =
      GoRouter(initialLocation: AppPath.onboard, routes: <GoRoute>[
    GoRoute(path: AppPath.onboard, builder: (context, state) => OnboardOne()),
    GoRoute(path: AppPath.onboard2, builder: (context, state) => OnboardTwo()),
    GoRoute(path: AppPath.onboard3, builder: (context, state) => OnboardThree())
  ]);
}
