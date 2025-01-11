import 'package:flutter/material.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/Home/presentation/screens/home_navigation_screen.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_one.dart';
import 'package:go_router/go_router.dart';



final routes = <GoRoute>[
    GoRoute(
      name: 'home',
      path: AppPath.home, 
      builder: (context, state) => const HomeNavigationScreen(index: 0)
    ),
    GoRoute(
    name: 'auth_onboarding',
    path: AppPath.authOnboarding,
    builder: (BuildContext context, GoRouterState state) =>
        const OnboardOne(),
  ),

];


GoRouter routerConfig() {
  return GoRouter(
    initialLocation: AppPath.authOnboarding,
    routes: routes,
  );
}


class AppRouter extends StatelessWidget {
  final GoRouter router;

  late String title;
  late String image;
  
  AppRouter({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
