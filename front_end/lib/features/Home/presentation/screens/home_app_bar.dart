import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/screens/update_profile_screen.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/screens/update_profile_screen.dart';
import 'package:go_router/go_router.dart';

class AppbarHome extends StatefulWidget implements PreferredSizeWidget {
  final BuildContext context;
  const AppbarHome({super.key, required this.context});

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  State<AppbarHome> createState() => _AppbarHomeState();
}

class _AppbarHomeState extends State<AppbarHome> {
  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  String role = "";
  String? userId;

  @override
  void initState() {
    super.initState();
    getRoleAndId();
  }

  Future<void> getRoleAndId() async {
    final userCredential = await flutterSecureStorage.read(key: 'user_profile');
    if (userCredential != null) {
      final userProfile = json.decode(userCredential);
      setState(() {
        role = userProfile["Role"] ?? "";
        userId = userProfile["_id"]?.toString();
      });

      if (role == "therapist" && userId != null) {
        widget.context.read<TherapistProfileBloc>().add(GetTherapistLoadEvent(therapistId: userId!));
      } else if (role == "patient" && userId != null) {
        widget.context.read<PatientProfileBloc>().add(GetPatientLoadEvent(patientId: userId!));
      }
    } else {
      // Dispatch logout event if user_profile is null
      widget.context.read<AuthBloc>().add(LogoutEvent());
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
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.message)),
            // );
            GoRouter.of(context).go(AppPath.login);
          } else if (state.status == AuthStatus.error) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.message)),
            // );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 45, bottom: 16, right: 8),
        child: Row(
          children: [
            Expanded(
              child: role == "therapist"
                      ? BlocBuilder<TherapistProfileBloc, GetTherapistState>(
                          builder: (context, state) => buildProfileContent(context, state),
                        )
                      : BlocBuilder<PatientProfileBloc, GetPatientState>(
                          builder: (context, state) => buildProfileContent(context, state),
                        ),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  Widget buildProfileContent(BuildContext context, dynamic state) {
    if (role == "therapist" && state is GetTherapistLoaded) {
      String userName = state.therapist.name;
      String profilePicture = state.therapist.profilePicture ?? "";
      bool hasPassword = state.therapist.hasPassword;
      String email = state.therapist.email;

      return buildProfileUI(context, userName, profilePicture, hasPassword, email);
    } else if (role == "patient" && state is GetPatientLoaded) {
      String userName = state.patient.name;
      String profilePicture = state.patient.profilePicture ?? "";
      bool hasPassword = state.patient.hasPassword;
      String email = state.patient.email;

      return buildProfileUI(context, userName, profilePicture, hasPassword, email);
    } else if ((role == "therapist" && state is GetTherapistError) ||
        (role == "patient" && state is GetPatientError)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuthBloc>().add(LogoutEvent());
      });
      return const SizedBox();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget buildProfileUI(BuildContext context, String userName, String profilePicture, bool hasPassword, String email) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => role == "therapist"
                    ? TherapistProfileNew(
                        username: userName,
                        profilePicture: profilePicture,
                        email: email,
                        therapistId: userId ?? "",
                        hasPassword: hasPassword,
                      )
                    : UpdatePatientProfileNew(
                        profilePicture: profilePicture,
                        username: userName,
                        hasPassword: hasPassword,
                        email: email,
                        patientId: userId!,
                      ),
              ),
            );
          },
          child: CircleAvatar(
            backgroundColor: Theme.of(context).brightness != Brightness.dark
                ? const Color(0xeEBEEF55)
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
            const SizedBox(height: 10),
            Text('👋', style: Theme.of(context).textTheme.bodySmall),
            Text('Hello, ${cutUsername(userName)}', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}