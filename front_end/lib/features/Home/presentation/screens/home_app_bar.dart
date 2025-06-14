import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:front_end/features/calendar/presentation/screen/calendar_screen.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/screens/update_profile_screen.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/screens/update_profile_screen.dart';
import 'package:go_router/go_router.dart';

class AppbarHome extends StatefulWidget implements PreferredSizeWidget {
  final String userId;
  final String role;

  const AppbarHome({super.key, required this.userId, required this.role});

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  State<AppbarHome> createState() => _AppbarHomeState();
}

class _AppbarHomeState extends State<AppbarHome> {
  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    if (widget.role == "therapist" || widget.role == "pending_therapist") {
      context.read<TherapistProfileBloc>().add(GetTherapistLoadEvent(therapistId: widget.userId));
    } else if (widget.role == "patient") {
      context.read<PatientProfileBloc>().add(GetPatientLoadEvent(patientId: widget.userId));
    }
  }

  String cutUsername(String username) {
    return username.length > 12 ? '${username.substring(0, 12)}...' : username;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
    ));

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserLogoutState && state.status == AuthStatus.loaded) {
          GoRouter.of(context).go(AppPath.login);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.9),
              Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.role == "therapist" || widget.role == "pending_therapist"
                    ? BlocBuilder<TherapistProfileBloc, GetTherapistState>(
                        builder: (context, state) => buildProfileContent(context, state),
                      )
                    : BlocBuilder<PatientProfileBloc, GetPatientState>(
                        builder: (context, state) => buildProfileContent(context, state),
                      ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CalendarScreen()),
                        );
                      },
                      icon: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.calendar_month_sharp, size: 24),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      tooltip: 'Calendar',
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileContent(BuildContext context, dynamic state) {
    if (widget.role == "pending_therapist" && state is GetTherapistLoaded) {
      return buildPendingTherapistUI(
        context,
        state.therapist.name,
        state.therapist.profilePicture ?? "",
        state.therapist.email,
      );
    } else if ((widget.role == "therapist" && state is GetTherapistLoaded) ||
        (widget.role == "patient" && state is GetPatientLoaded)) {
      final userName = widget.role == "therapist" ? (state as GetTherapistLoaded).therapist.name : (state as GetPatientLoaded).patient.name;
      final profilePicture = widget.role == "therapist" ? state.therapist.profilePicture ?? "" : state.patient.profilePicture ?? "";
      final hasPassword = widget.role == "therapist" ? state.therapist.hasPassword : state.patient.hasPassword;
      final email = widget.role == "therapist" ? state.therapist.email : state.patient.email;

      return buildProfileUI(context, userName, profilePicture, hasPassword, email);
    } else if ((widget.role == "therapist" && state is GetTherapistError) ||
        (widget.role == "patient" && state is GetPatientError) ||
        (widget.role == "pending_therapist" && state is GetTherapistError)) {
      return buildProfileUI(context, "User", "", true, "email@example.com");
    } else {
      return const SizedBox(
        width: 150,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
  }

  Widget buildProfileUI(BuildContext context, String userName, String profilePicture, bool hasPassword, String email) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.role == "therapist"
                ? TherapistProfileNew(
                    username: userName,
                    profilePicture: profilePicture,
                    email: email,
                    therapistId: widget.userId,
                    hasPassword: hasPassword,
                  )
                : UpdatePatientProfileNew(
                    profilePicture: profilePicture,
                    username: userName,
                    hasPassword: hasPassword,
                    email: email,
                    patientId: widget.userId,
                  ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profilePicture,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                  errorWidget: (context, url, error) => const Icon(Icons.person, size: 30, color: Colors.grey),
                ),
              ),
            ),
          ).animate().scale(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeInOut,
                begin: Offset(1.0, 1.0),
                end: Offset(1.05, 1.05),
              ).then().scale(
                duration: const Duration(milliseconds: 2000),
                begin: Offset(1.05, 1.05),
                end: Offset(1.0, 1.0),
              ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Hello, ${cutUsername(userName)}',
                    textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              Text(
                widget.role == "therapist" ? 'Therapist' : 'Patient',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPendingTherapistUI(BuildContext context, String userName, String profilePicture, String email) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PendingTherapistScreen(
              username: userName,
              email: email,
              therapistId: widget.userId,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[300],
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: profilePicture,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (context, url, error) => const Icon(Icons.person, size: 30, color: Colors.grey),
                    ),
                  ),
                ),
              ).animate().scale(
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.easeInOut,
                    begin: Offset(1.0, 1.0),
                    end: Offset(1.05, 1.05),
                  ).then().scale(
                    duration: const Duration(milliseconds: 2000),
                    begin: Offset(1.05, 1.05),
                    end: Offset(1.0, 1.0),
                  ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[600],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Pending',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Hi, ${cutUsername(userName)}',
                    textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              Text(
                'Account under review',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange[600],
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoreMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        if (value == 'profile') {
          final state = widget.role == "therapist" || widget.role == "pending_therapist"
              ? context.read<TherapistProfileBloc>().state
              : context.read<PatientProfileBloc>().state;
          String userName = "User";
          String profilePicture = "";
          bool hasPassword = true;
          String email = "email@example.com";

          if (state is GetTherapistLoaded) {
            userName = state.therapist.name;
            profilePicture = state.therapist.profilePicture ?? "";
            hasPassword = state.therapist.hasPassword;
            email = state.therapist.email;
          } else if (state is GetPatientLoaded) {
            userName = state.patient.name;
            profilePicture = state.patient.profilePicture ?? "";
            hasPassword = state.patient.hasPassword;
            email = state.patient.email;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.role == "therapist"
                  ? TherapistProfileNew(
                      username: userName,
                      profilePicture: profilePicture,
                      email: email,
                      therapistId: widget.userId,
                      hasPassword: hasPassword,
                    )
                  : widget.role == "pending_therapist"
                      ? PendingTherapistScreen(
                          username: userName,
                          email: email,
                          therapistId: widget.userId,
                        )
                      : UpdatePatientProfileNew(
                          profilePicture: profilePicture,
                          username: userName,
                          hasPassword: hasPassword,
                          email: email,
                          patientId: widget.userId,
                        ),
            ),
          );
        } else if (value == 'logout') {
          context.read<AuthBloc>().add(LogoutEvent());
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20),
              SizedBox(width: 8),
              Text('View Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 20),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surface,
      elevation: 4,
    );
  }
}

class PendingTherapistScreen extends StatelessWidget {
  final String username;
  final String email;
  final String therapistId;

  const PendingTherapistScreen({
    super.key,
    required this.username,
    required this.email,
    required this.therapistId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Verification'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40, color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, $username!',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  email,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: 0.5, // Placeholder; update dynamically if API provides progress
                          backgroundColor: Colors.grey[200],
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your account is under review',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.orange[600],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: const Duration(milliseconds: 600)),
                const SizedBox(height: 24),
                Text(
                  'What to Expect',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                _buildInfoTile(context, '📩', 'Approval Email', 'You’ll receive an email once your account is approved.'),
                _buildInfoTile(context, '⏰', 'Verification Time', 'Typically takes 1-3 business days.'),
                _buildInfoTile(context, '📞', 'Support', 'Contact support for any questions.'),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ).animate().slideY(
                        begin: 0.5,
                        end: 0.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ).animate().fadeIn(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 200),
          ),
    );
  }
}