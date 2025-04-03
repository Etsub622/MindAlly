import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front_end/core/routes/routes.dart';
import 'package:front_end/core/utils/constants.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/delete_patient_bloc/delete_patient_bloc.dart';
import 'package:front_end/features/profile_patient/presentation/bloc/get_patient_bloc/get_patient_bloc.dart';
import 'package:go_router/go_router.dart';

class ManagePatientScreen extends StatefulWidget {
  final String userName;
  final String email;
  final String patientId;

  const ManagePatientScreen({
    required this.userName,
    required this.email,
    required this.patientId,
    super.key,
  });

  @override
  State<ManagePatientScreen> createState() => ManagePatientScreenState();
}

enum UserNameStatus { unknown, available, notAvailable }

class ManagePatientScreenState extends State<ManagePatientScreen> {
  final _userNameController = TextEditingController();
  
  TextEditingController currencyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  UserNameStatus usernameIdFound = UserNameStatus.unknown;
  bool isLoading = false;
  String userName = "your username";
  String email = "your email";
  bool hasPassword = true;
  String profilePicture = "";
  ValueNotifier<bool> isPasswordUpdating = ValueNotifier(false);
  ValueNotifier<bool> isUserNameUpdating = ValueNotifier(false);

  String? imagePath;

  
 



  @override
  void initState() {
    super.initState();
    // setState(() {
    //   hasPassword = hasPassword;
    // });
    context.read<PatientProfileBloc>().add(GetPatientLoadEvent(patientId: widget.patientId));
    _userNameController.text = widget.userName;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    return PopScope(
        onPopInvoked: (v) {
          context.read<PatientProfileBloc>().add(
                GetPatientLoadEvent(patientId: widget.patientId),
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
                  // color: Colors.red,
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
              body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      child: ListView(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                                radius: 30,
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                        imageUrl: profilePicture,
                                        placeholder: (context, url) =>
                                            const Image(
                                                image: AssetImage(AppImage
                                                    .loadingPlaceholder)),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.hexToColor("#00538C"),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              userName,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Profile',
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                   },
                                  title: Text("User Name",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                  trailing: SizedBox(
                                    width: width * 0.4,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: width * 0.3,
                                          child: Text(
                                            widget.userName,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColor.hexToColor(
                                                    "#73777F")),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 14,
                                          color: AppColor.hexToColor("#73777F"),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Email",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  trailing: SizedBox(
                                    width: width * 0.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            widget.email,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColor.hexToColor(
                                                    "#73777F")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Security',
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                   
                                  },
                                  title: Text("Password",
                                      style:
                                          Theme.of(context).textTheme.bodyMedium
                                      // TextStyle(
                                      //     fontSize: 14,
                                      //     color: AppColor.hexToColor("#181C21")),
                                      ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: AppColor.hexToColor("#73777F"),
                                  ),
                                ),
                                ListTile(
                                  trailing: SvgPicture.asset(AppImage.logoutsvg,
                                      color: Colors.red),
                                  subtitle: Text("Do you want to logout?",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              AppColor.hexToColor("#73777F"))),
                                  title: Text(
                                    'Log out',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.red),
                                  ),
                                  onTap: () {
                                    _showDialog(context);
                                  },
                                ),
                                ListTile(
                                  trailing: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                  subtitle: Text("Your account will be deleted",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              AppColor.hexToColor("#73777F"))),
                                  title: Text(
                                    'Delete Account',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.red),
                                  ),
                                  onTap: () {
                                    _showDeleteAccountDialog(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
        //   })),
        // )
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<DeletePatientBloc, DeletePatientState>(
          listener: (context, state) {
            if (state is DeletePatientLoaded) {
                GoRouter.of(context).go(AppPath.login);
              } else if (state is DeletePatientError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
          },
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Delete Account'),
              content: const Text('Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<DeletePatientBloc>().add(DeletePatientLoadEvent(patientId: widget.patientId));
                  },
                  child: const Text(
                    'Delete Account',
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
