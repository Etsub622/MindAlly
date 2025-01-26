import 'package:flutter/material.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/Home/presentation/screens/home_navigation_screen.dart';
import 'package:front_end/features/authentication/presentation/screens/forgot_password.dart';
import 'package:front_end/features/authentication/presentation/screens/login.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_one.dart';
import 'package:front_end/features/authentication/presentation/screens/otp.dart';
import 'package:front_end/features/authentication/presentation/screens/professional_signUp.dart';
import 'package:front_end/features/authentication/presentation/screens/reset_password.dart';
import 'package:front_end/features/authentication/presentation/screens/role_selection.dart';
import 'package:front_end/features/authentication/presentation/screens/student_signUp.dart';

import 'package:go_router/go_router.dart';

final routes = <GoRoute>[
  GoRoute(
      name: 'home',
      path: AppPath.home,
      builder: (context, state) => const HomeNavigationScreen(index: 0)),
  GoRoute(
    name: 'auth_onboarding',
    path: AppPath.authOnboarding,
    builder: (BuildContext context, GoRouterState state) => const OnboardOne(),
  ),
  GoRoute(
      path: AppPath.role, builder: (context, state) => const RoleSelection()),
  GoRoute(
      path: AppPath.student,
      builder: (context, state) => const StudentSignUp()),
  GoRoute(
      path: AppPath.professional,
      builder: (context, state) => const ProfessionalSignup()),
  GoRoute(path: AppPath.login, builder: (context, state) => const Login()),
  GoRoute(
      path: AppPath.forgotPassword,
      builder: (context, state) => const ForgotPassword()),
  GoRoute(
      path: AppPath.resetPassword,
      builder: (context, state) {
        final extra = state.extra as Map<String, String>;
        final resetToken = extra['resetToken']!;
        return ResetPassword(resetToken: resetToken);
      }),
  GoRoute(
      path: AppPath.otp,
      builder: (context, state) {
        final email = state.extra as String;
        return OtpVerification(email: email);
      }),
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
