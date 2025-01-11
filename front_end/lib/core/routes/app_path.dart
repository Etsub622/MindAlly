class AppPath {
  static const authOnboarding = '/authOnboarding';
  
  static const String login = '/login';

  static const String signup = '/signup';

  static const String home = '/';
  static const String onboard2 = '/onboard2';
  static const String onboard3 = '/onboard3';
}

const List<String> publicRoutes = [
];

const List<String> authRoutes = [
  AppPath.authOnboarding,
  AppPath.login,
  AppPath.signup,
];

const List<String> protectedRoutes = [
  AppPath.home,
];