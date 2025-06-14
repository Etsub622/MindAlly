import 'package:flutter/material.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/Home/presentation/screens/home_navigation_screen.dart';
import 'package:front_end/features/Home/presentation/screens/therapist_detail_screen.dart';
import 'package:front_end/features/admin/admin_screen.dart';
import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';
import 'package:front_end/features/authentication/data/models/professional_signup_model.dart';
import 'package:front_end/features/authentication/data/models/student_signup_model.dart';
import 'package:front_end/features/authentication/presentation/screens/forgot_password.dart';
import 'package:front_end/features/authentication/presentation/screens/login.dart';
import 'package:front_end/features/authentication/presentation/screens/otp.dart';
import 'package:front_end/features/authentication/presentation/screens/patient_onboarding.dart';
import 'package:front_end/features/authentication/presentation/screens/professional_signUp.dart';
import 'package:front_end/features/authentication/presentation/screens/reset_password.dart';
import 'package:front_end/features/authentication/presentation/screens/role_selection.dart';
import 'package:front_end/features/authentication/presentation/screens/student_signUp.dart';
import 'package:front_end/features/authentication/presentation/screens/therapist_onboarding.dart';
import 'package:front_end/features/calendar/presentation/screen/calendar_screen.dart';
import 'package:front_end/features/chat/presentation/screens/chat_page.dart';
import 'package:front_end/features/chat/presentation/screens/chat_room.dart';
import 'package:front_end/features/profile_patient/domain/entities/user_entity.dart';
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';
import 'package:front_end/features/resource/presentation/screens/book_resource.dart';

import 'package:go_router/go_router.dart';

final routes = <GoRoute>[
  GoRoute(
      name: 'home',
      path: AppPath.home,
      builder: (context, state) => const HomeNavigationScreen(index: 0)),
  GoRoute(
    name: 'therapist_onboard',
    path: AppPath.therapistOnboard,
    builder: (BuildContext context, GoRouterState state) =>
        const TherapistOnboardingScreen(),
  ),
  GoRoute(
    name: 'patient_onboard',
    path: AppPath.patientOnboard,
    builder: (BuildContext context, GoRouterState state) =>
        const PatientOnboardingSreen(),
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
      path: AppPath.bookResource, builder: (context, state) => BookResource()),
  GoRoute(
    path: AppPath.otp,
    builder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return OtpVerification(
        email: extra['email'] as String,
        verificationType: extra['verificationType'] as String,
        student: extra['student'] as StudentSignupModel?,
        professional: extra['professional'] as ProfessionalSignupModel?,
      );
    },
  ),
  GoRoute(
    name: 'chat',
    path: AppPath.chat,
    builder: (BuildContext context, GoRouterState state) => const ChatRoom(),
  ),
  GoRoute(
    name: 'chatDetails',
    path: AppPath.chatDetails,
    builder: (BuildContext context, GoRouterState state) => ChatPage(
      chatId: state.uri.queryParameters['chatId'],
      receiver: UserEntity(
          id: state.uri.queryParameters['id'] ?? "",
          name: state.uri.queryParameters['name'] ?? "",
          email: state.uri.queryParameters['email'] ?? "",
          hasPassword:
              state.uri.queryParameters['hasPassword'] == "true" ? true : false,
          role: state.uri.queryParameters['role'] ?? ""),
    ),
  ),
  GoRoute(
      name: "calendar",
      path: AppPath.calendar,
      builder: (BuildContext context, GoRouterState state) =>
          const CalendarScreen()),
  GoRoute(
      name: "admin",
      path: AppPath.admin,
      builder: (BuildContext context, GoRouterState state) =>
          const AdminDashboardScreen()),
  GoRoute(
    path: '/therapistDetails',
    name: 'therapistDetails',
    builder: (context, state) {
      final therapist = state.extra as UpdateTherapistEntity;
      return TherapistDetailPage(therapist: therapist);
    },
  ),
];

GoRouter routerConfig() {
  return GoRouter(
    initialLocation: AppPath.home,
    routes: routes,
  );
}

class AppRouter extends StatelessWidget {
  final GoRouter router;

  void popUntil(bool Function(String) predicate) {
    while (!predicate(router.routerDelegate.currentConfiguration.fullPath)) {
      router.pop();
    }
  }

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
