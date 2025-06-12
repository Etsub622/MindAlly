class AppPath {  
  static const String login = '/login';

  static const String signup = '/signup';

  static const String home = '/home';
  static const String therapistOnboard = '/therapistOnboard';
  static const String patientOnboard=  '/patientOnboard';
  static const String role = '/role';
  static const String student = '/student';
  static const String professional = '/professional';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String otp = '/otp';
  static String bookResource ='bookResource';
  static const String chat = '/chat';
  static const String chatDetails = '/chatDetails';
  static const String calendar = '/calendar';
  static const String admin = "/admin";
}

const List<String> publicRoutes = [
];

const List<String> authRoutes = [
  AppPath.patientOnboard,
  AppPath.therapistOnboard,
  AppPath.login,
  AppPath.signup,
];

const List<String> protectedRoutes = [
  AppPath.home,
  AppPath.chat,
  AppPath.chatDetails,
  AppPath.calendar,
  AppPath.admin
];