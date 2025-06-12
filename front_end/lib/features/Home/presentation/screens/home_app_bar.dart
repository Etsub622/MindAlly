import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Size get preferredSize => const Size.fromHeight(110);

  @override
  State<AppbarHome> createState() => _AppbarHomeState();
}

class _AppbarHomeState extends State<AppbarHome> {
  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    if (widget.role == "therapist" || widget.role == "pending_therapist") {
      BlocProvider.of<TherapistProfileBloc>(context).add(GetTherapistLoadEvent(therapistId: widget.userId));
    } else if (widget.role == "patient") {
      BlocProvider.of<PatientProfileBloc>(context).add(GetPatientLoadEvent(patientId: widget.userId));
    }
  }

  String cutUsername(String username) {
    if (username.length > 10) {
      username = '${username.substring(0, 10)}...';
    }
    return username;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
      statusBarColor: Theme.of(context).colorScheme.surface,
    ));

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserLogoutState) {
          if (state.status == AuthStatus.loaded) {
            GoRouter.of(context).go(AppPath.login);
          }
        }
      },
      child: AppBar(
        toolbarHeight: 110,
        title: widget.role == "therapist" || widget.role == "pending_therapist"
            ? BlocBuilder<TherapistProfileBloc, GetTherapistState>(
                builder: (context, state) => buildProfileContent(context, state),
              )
            : BlocBuilder<PatientProfileBloc, GetPatientState>(
                builder: (context, state) => buildProfileContent(context, state),
              ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarScreen(),
                ),
              );
            },
            icon: const Icon(Icons.calendar_month_sharp),
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget buildProfileContent(BuildContext context, dynamic state) {
    if (widget.role == "pending_therapist" && state is GetTherapistLoaded) {
      String userName = state.therapist.name;
      String profilePicture = state.therapist.profilePicture ?? "";
      String email = state.therapist.email;

      return buildPendingTherapistUI(context, userName, profilePicture, email);
    } else if (widget.role == "therapist" && state is GetTherapistLoaded) {
      String userName = state.therapist.name;
      String profilePicture = state.therapist.profilePicture ?? "";
      bool hasPassword = state.therapist.hasPassword;
      String email = state.therapist.email;

      return buildProfileUI(context, userName, profilePicture, hasPassword, email);
    } else if (widget.role == "patient" && state is GetPatientLoaded) {
      String userName = state.patient.name;
      String profilePicture = state.patient.profilePicture ?? "";
      bool hasPassword = state.patient.hasPassword;
      String email = state.patient.email;

      return buildProfileUI(context, userName, profilePicture, hasPassword, email);
    } else if ((widget.role == "therapist" && state is GetTherapistError) ||
        (widget.role == "patient" && state is GetPatientError) ||
        (widget.role == "pending_therapist" && state is GetTherapistError)) {
      return buildProfileUI(context, "userName", "profilePicture", true, "email");
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget buildProfileUI(BuildContext context, String userName, String profilePicture, bool hasPassword, String email) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
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
          child: CircleAvatar(
            backgroundColor: Theme.of(context).brightness != Brightness.dark
                ? const Color(0xEEBEEF55)
                : Colors.black,
            backgroundImage: CachedNetworkImageProvider(
              profilePicture,
              errorListener: (_) => const Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
            radius: 25,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('👋', style: Theme.of(context).textTheme.bodySmall),
            Text('Hello, ${cutUsername(userName)}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget buildPendingTherapistUI(BuildContext context, String userName, String profilePicture, String email) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
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
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: profilePicture.isNotEmpty
                    ? CachedNetworkImageProvider(
                        profilePicture,
                        errorListener: (_) => const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      )
                    : null,
                radius: 25,
                child: profilePicture.isEmpty
                    ? Icon(Icons.person, size: 30, color: Colors.grey[600])
                    : null,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Pending',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('⏳', style: Theme.of(context).textTheme.bodySmall),
            Text(
              'Hi, ${cutUsername(userName)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            Text(
              'Account under review',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: Colors.orange[600],
                  ),
            ),
          ],
        ),
      ],
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $username!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Your therapist account is currently under review. We’re verifying your credentials to ensure the best experience for our users.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
              subtitle: const Text('Registered email'),
            ),
            const SizedBox(height: 24),
            Text(
              'What to expect:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('• You’ll receive an email once your account is approved.'),
            const Text('• Verification typically takes 1-3 business days.'),
            const Text('• Contact support if you have questions.'),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
              child: const Text('Logout'),
            ),
            )
          ],
        ),
      ),
    );
  }
}