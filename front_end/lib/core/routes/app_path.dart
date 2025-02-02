class AppPath {
  static const authOnboarding = '/authOnboarding';
  
  static const String login = '/login';

  static const String signup = '/signup';

  static const String home = '/';
  static const String onboard2 = '/onboard2';
  static const String onboard3 = '/onboard3';
  static const String role = '/role';
  static const String student = '/student';
  static const String professional = '/professional';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String otp = '/otp';
  static String bookResource ='bookResource';
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