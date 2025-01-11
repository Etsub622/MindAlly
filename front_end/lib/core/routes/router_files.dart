import 'dart:async';

import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/core/routes/error_path.dart';
import 'package:front_end/core/routes/route_matcher.dart';
import 'package:front_end/core/routes/router_config.dart';
import 'package:front_end/injection_container.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  redirect: ((context, state) =>
      redirector(state, serviceLocator())),
  initialLocation: AppPath.authOnboarding,
  routes: routes,
  errorBuilder: (context, state) => const ErrorPage(
    message: 'page not found',
  ),
);

FutureOr<String?> redirector(
    GoRouterState state, Object object,
) async {
  var isLoggedIn = true;
 
  if (publicRoutes.contains(state.uri.toString())) {
    return state.uri.toString();
  }

  final isAuthRoute = authRouterMatcher.match(state.uri.toString());

  if (isLoggedIn) {
    // if the user is trying to access an auth route redirect to home page
    if (isAuthRoute != null) {
      return AppPath.home;
    }
    return AppPath.login;
} 
}