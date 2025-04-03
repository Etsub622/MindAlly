import 'dart:async';

import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/core/routes/error_path.dart';
import 'package:front_end/core/routes/route_matcher.dart';
import 'package:front_end/core/routes/router_config.dart';
import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/core/util/get_user_credential.dart';
import 'package:front_end/features/authentication/data/datasource/auth_local_datasource/login_local_datasource.dart';
import 'package:front_end/features/authentication/data/datasource/auth_remote_datasource/auth_remote_datasource.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  redirect: ((context, state) =>
      redirector(state, sl(), sl(), sl())),
  initialLocation: AppPath.home,
  routes: routes,
  errorBuilder: (context, state) => const ErrorPage(
    message: 'page not found',
  ),
);


FutureOr<String?> redirector(
    GoRouterState state,
    LoginLocalDataSource localDatasource,
     AuthRemoteDatasource remoteDatasource,
    NetworkInfo networkInfo) async {

  var isLoggedIn = false;
  // var isAppInitialized = true;
  

  try {
    final userCred = await getUserCredential();
    final token = await localDatasource.getToken();

    isLoggedIn = userCred != null && token != '';
  } on CacheException {
    isLoggedIn = false;
  }

  // try {
  //   final userCred = getAppInitialization();
  // } on CacheException {
  //   isAppInitialized = false;
  // }

  //if the path is a public route, return it

  if (publicRoutes.contains(state.uri.toString())) {
    return state.uri.toString();
  }

  final isAuthRoute = authRouterMatcher.match(state.uri.toString());

  if (isLoggedIn) {
    // if the user is trying to access an auth route redirect to home page
    if (isAuthRoute != null) {
      return AppPath.home;
    }

    // if the user is trying to access an invalid protected route return null which will be resolved by the go router
    // check if the redirect url is set
    // final redirectUrl = await localDatasource.getRedirectUrl();
    // await localDatasource.clearRedirectUrl();
    // return redirectUrl ?? state.uri.toString();

    // redirect to the location
  } else if (isAuthRoute != null) {
    return state.uri.toString();
  } else {
    // check if the redirect url is a valid url
    // if (state.fullPath == AppPath.newShareChatPage) {
    //   await localDatasource.setRedirectUrl(state.uri.toString());
    // }
    return AppPath.login;
  }
  return AppPath.login;
}
