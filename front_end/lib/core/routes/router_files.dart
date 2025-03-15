import 'dart:async';

import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/core/routes/error_path.dart';
import 'package:front_end/core/routes/route_matcher.dart';
import 'package:front_end/core/routes/router_config.dart';
import 'package:front_end/core/injection/injections.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final router = GoRouter(
  redirect: ((context, state) =>
      redirector(state, sl())),
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
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final userCredential = sharedPreferences.getString('user_profile');
  
  if(userCredential == null){
    isLoggedIn = false;
  }
 
  if (publicRoutes.contains(state.uri.toString())) {
    return state.uri.toString();
  }

  if (isLoggedIn) {
    // if the user is trying to access an auth route redirect to home page
    return AppPath.home;  
} 
return AppPath.login;
}