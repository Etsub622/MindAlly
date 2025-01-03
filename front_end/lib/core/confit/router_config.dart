import 'package:front_end/core/confit/app_path.dart';
import 'package:front_end/features/authentication/presentation/screens/forgot_password.dart';
import 'package:front_end/features/authentication/presentation/screens/login.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_one.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_three.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_two.dart';
import 'package:front_end/features/authentication/presentation/screens/otp.dart';
import 'package:front_end/features/authentication/presentation/screens/professional_signUp.dart';
import 'package:front_end/features/authentication/presentation/screens/reset_password.dart';
import 'package:front_end/features/authentication/presentation/screens/role_selection.dart';
import 'package:front_end/features/authentication/presentation/screens/student_signUp.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router =
      GoRouter(initialLocation: AppPath.onboard, routes: <GoRoute>[
    GoRoute(path: AppPath.onboard, builder: (context, state) => OnboardOne()),
    GoRoute(path: AppPath.onboard2, builder: (context, state) => OnboardTwo()),
    GoRoute(
        path: AppPath.onboard3, builder: (context, state) => OnboardThree()),
    GoRoute(path: AppPath.role, builder: (context, state) => RoleSelection()),
    GoRoute(
        path: AppPath.student, builder: (context, state) => StudentSignUp()),
    GoRoute(
        path: AppPath.professional,
        builder: (context, state) => ProfessionalSignup()),
    GoRoute(path: AppPath.login, builder: (context, state) => Login()),
    GoRoute(
        path: AppPath.forgotPassword,
        builder: (context, state) => ForgotPassword()),
    GoRoute(
        path: AppPath.resetPassword,
        builder: (context, state) => ResetPassword()),
    GoRoute(
        path: AppPath.otp,
        builder: (context, state) {
          final email = state.extra as String;
          return OtpVerification(email: email);
        }),
  ]);
}
