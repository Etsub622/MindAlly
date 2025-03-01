import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/profile/presentation/bloc/user_profile_bloc.dart';
import 'package:front_end/features/profile/presentation/screens/profile_body_screen.dart';
import 'package:go_router/go_router.dart';

class UpdateProfileNew extends StatefulWidget {
  final String profilePicture;
  final String username;
  final String hasPassword;
  final String email;

  const UpdateProfileNew({
    Key? key,
    required this.profilePicture,
    required this.username,
    required this.hasPassword,
    required this.email,
  }) : super(key: key);

  @override
  State<UpdateProfileNew> createState() => UpdateProfileNewState();
}

enum LanugageMode { english }

enum CustomThemeMode { light }

class UpdateProfileNewState extends State<UpdateProfileNew> {
  final _userNameController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  
  bool usernameIdFound = true;
  bool isLoading = false;
  String hasPassword = "true";
  String? validatePassword(String? password) {
    if (password == null || password == "") {
      return "Password can not be empty";
    }
    if (password.length < 8) {
      return "Password must be atleast 8 characters long";
    }
    return null;
  }



  @override
  void initState() {
    super.initState();
    setState(() {
      hasPassword = widget.hasPassword;
    });
    _userNameController.text = widget.username;
    context.read<UserProfileBloc>().add(GetUserProfileEvent());

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (v) {
        context.read<UserProfileBloc>().add(
              GetUserProfileEvent(),
            );
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: ProfilePageBody(profile: widget)),
    );
  }
}
