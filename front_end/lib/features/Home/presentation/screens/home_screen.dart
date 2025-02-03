import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/Home/presentation/screens/home_app_bar.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarHome(context: context),
      // AppBar(
      //   title: Text('Home Screen'),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.logout),
      //       onPressed: () => _showDialog(context),
      //     ),
      //   ],
      // ),
      body: const Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is UserLogoutState) {
              if (state.status == AuthStatus.loaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                GoRouter.of(context).go(AppPath.login);
              } else if (state.status == AuthStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Log Out'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
