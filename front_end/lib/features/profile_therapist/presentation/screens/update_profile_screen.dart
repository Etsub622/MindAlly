import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/screens/profile_body_screen.dart';
import 'package:go_router/go_router.dart';

class TherapistProfileNew extends StatefulWidget {
  final String profilePicture;
  final String username;
  final bool hasPassword;
  final String email;
  final String therapistId;
  final PayoutModel? payout;

  const TherapistProfileNew({
    Key? key,
    required this.profilePicture,
    required this.username,
    required this.hasPassword,
    required this.email,
    required this.therapistId,
    this.payout,
  }) : super(key: key);

  @override
  State<TherapistProfileNew> createState() => TherapistProfileNewState();
}

// enum LanugageMode { english }

// enum CustomThemeMode { light }

class TherapistProfileNewState extends State<TherapistProfileNew> {
  final _userNameController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  
  bool usernameIdFound = true;
  bool isLoading = false;
  bool hasPassword = true;
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
    context.read<TherapistProfileBloc>().add(GetTherapistLoadEvent(therapistId: widget.therapistId));

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (v) {
        context.read<TherapistProfileBloc>().add(
              GetTherapistLoadEvent(therapistId: widget.therapistId),
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
          body: TherapistProfilePageBody(
            profile: 
          TherapistProfileNew(
            profilePicture: widget.profilePicture, 
            username: widget.username, 
            hasPassword: widget.hasPassword, 
            email: widget.email,
            therapistId: widget.therapistId,
            payout: widget.payout,
          )),
    ));
  }
}
