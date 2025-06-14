import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/core/utils/constants.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/Home/presentation/screens/home_screen.dart';
import 'package:front_end/features/admin/admin_screen.dart';
import 'package:front_end/features/admin/events_admin_screen.dart';
import 'package:front_end/features/admin/unapproved_therapists_screen.dart';
import 'package:front_end/features/approve_therapist/presentation/screen/therapist_list_page.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/chat/presentation/screens/chat_room.dart';
import 'package:front_end/features/Q&A/presentation/screens/qa_room.dart';
import 'package:front_end/features/resource/presentation/screens/resource_room.dart';
import 'package:go_router/go_router.dart';

class HomeNavigationScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic>? extra;
  const HomeNavigationScreen({super.key, required this.index, this.extra});

  @override
  State<HomeNavigationScreen> createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  final FlutterSecureStorage flutterSecureStorage = const FlutterSecureStorage();
  String? role;
  String? userId;
  int index = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize index
    updateIndex();
    getRoleAndId();
  }

  @override
  void didUpdateWidget(HomeNavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update index if extra changes
    if (widget.extra != oldWidget.extra || widget.index != oldWidget.index) {
      updateIndex();
    }
  }

  void updateIndex() {
    setState(() {
      index = (widget.extra != null && widget.extra!['index'] != null)
          ? widget.extra!['index'] as int
          : widget.index;
      print("Updated index: $index, extra: ${widget.extra}"); // Debug log
    });
  }

  Future<void> getRoleAndId() async {
    final userCredential = await flutterSecureStorage.read(key: 'user_profile');
    if (userCredential != null) {
      final userProfile = json.decode(userCredential);
      setState(() {
        role = userProfile["Role"] ?? "";
        userId = userProfile["_id"]?.toString() ?? "";
        isLoading = false;
      });
      if (role!.isEmpty || userId!.isEmpty) {
        context.read<AuthBloc>().add(LogoutEvent());
      }
    } else {
      setState(() {
        isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuthBloc>().add(LogoutEvent());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserLogoutState) {
          if (state.status == AuthStatus.loaded) {
            GoRouter.of(context).go(AppPath.login);
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        }
      },
      child: Builder(
        builder: (context) {
          if (isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (role == null || userId == null || role!.isEmpty || userId!.isEmpty) {
            return const Scaffold(
              body: Center(child: Text("Logging out...")),
            );
          }
          List<StatefulWidget> screens = [];

          role != "admin"
              ? screens = [
                  HomeScreen(role: role!, userId: userId!),
                  QARoom(currentUserRole: role!),
                  const ResourceRoom(),
                  const ChatRoom(),
                ]
              : screens = [
                  EventsAdminScreen(),
                  TherapistListPage(),
                ];

          return Scaffold(
            body: Center(
              child: Stack(
                children: [screens[index]],
              ),
            ),
            bottomNavigationBar: ClipRect(
              child: BottomNavigationBar(
                backgroundColor: Colors.black,
                currentIndex: index,
                unselectedItemColor: Colors.white,
                selectedItemColor: Colors.white,
                unselectedLabelStyle: const TextStyle(color: Colors.white),
                selectedLabelStyle: const TextStyle(color: Colors.white),
                type: BottomNavigationBarType.fixed,
                onTap: (int newIndex) {
                  setState(() {
                    index = newIndex;
                    print("Bottom nav tapped: $index"); // Debug log
                  });
                },
                items: role != "admin"
                    ? [
                        BottomNavigationBarItem(
                          icon: index == 0
                              ? Image.asset(width: 30, height: 40, AppImage.homeSelected)
                              : Image.asset(width: 30, height: 40, AppImage.homeUnselected),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: index == 1
                              ? Image.asset(width: 30, height: 40, AppImage.qaSelected)
                              : Image.asset(width: 30, height: 40, AppImage.qaUnselected),
                          label: 'Q&A',
                        ),
                        BottomNavigationBarItem(
                          icon: index == 2
                              ? Image.asset(width: 30, height: 40, AppImage.resourceSelected)
                              : Image.asset(width: 30, height: 40, AppImage.resourceUnselected),
                          label: 'Resource',
                        ),
                        BottomNavigationBarItem(
                          icon: index == 3
                              ? Image.asset(width: 30, height: 40, AppImage.chatSelected)
                              : Image.asset(width: 30, height: 40, AppImage.chatUnselected),
                          label: 'Chat',
                        ),
                      ]
                    : [
                        BottomNavigationBarItem(
                          icon: index == 0
                              ? Image.asset(width: 30, height: 40, AppImage.resourceSelected)
                              : Image.asset(width: 30, height: 40, AppImage.resourceUnselected),
                          label: 'events',
                        ),
                        BottomNavigationBarItem(
                          icon: index == 1
                              ? Image.asset(width: 30, height: 40, AppImage.chatSelected)
                              : Image.asset(width: 30, height: 40, AppImage.chatUnselected),
                          label: 'therapist',
                        ),
                      ],
              ),
            ),
          );
        },
      ),
    );
  }
}