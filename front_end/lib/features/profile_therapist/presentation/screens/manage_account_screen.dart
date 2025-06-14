import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front_end/core/routes/routes.dart';
import 'package:front_end/core/utils/constants.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/delete_therapist_bloc/delete_therapist_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/get_therapist_bloc/get_therapist_bloc.dart';
import 'package:front_end/features/profile_therapist/presentation/bloc/update_therapist_bloc/update_therapist_bloc.dart';
import 'package:go_router/go_router.dart';

class ManageTherapistScreen extends StatefulWidget {
  final String userName;
  final String email;
  final String therapistId;
  final PayoutModel? payout;

  const ManageTherapistScreen({
    required this.userName,
    required this.email,
    required this.therapistId,
    this.payout,
    super.key,
  });

  @override
  State<ManageTherapistScreen> createState() => ManageTherapistScreenState();
}

enum UserNameStatus { unknown, available, notAvailable }

class ManageTherapistScreenState extends State<ManageTherapistScreen> {
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
    context.read<TherapistProfileBloc>().add(GetTherapistLoadEvent(therapistId: widget.therapistId));
    _userNameController.text = widget.userName;
  }

  void _showPayoutBottomSheet(BuildContext context, {PayoutModel? existingPayout}) {
    final formKey = GlobalKey<FormState>();
    final accountNameController = TextEditingController(text: existingPayout?.accountName ?? '');
    final accountNumberController = TextEditingController(text: existingPayout?.accountNumber ?? '');
    final bankCodeController = TextEditingController(text: existingPayout?.bankCode ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BlocConsumer<UpdateTherapistBloc, UpdateTherapistState>(
          listener: (context, state) {
            if (state is UpdateTherapistLoaded) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payout details updated successfully')),
              );
              context.read<TherapistProfileBloc>().add(GetTherapistLoadEvent(therapistId: widget.therapistId));
            } else if (state is UpdateTherapistError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existingPayout == null ? 'Add Payout Method' : 'Update Payout Method',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: accountNameController,
                      decoration: InputDecoration(
                        labelText: 'Account Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: accountNumberController,
                      decoration: InputDecoration(
                        labelText: 'Account Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: bankCodeController,
                      decoration: InputDecoration(
                        labelText: 'Bank Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter bank code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: state is UpdateTherapistLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  final payout = PayoutModel(
                                    accountName: accountNameController.text,
                                    accountNumber: accountNumberController.text,
                                    bankCode: bankCodeController.text,
                                  );
                                  context.read<UpdateTherapistBloc>().add(
                                        UpdateTherapistLoadEvent(
                                          therapist: UpdateTherapistModel(
                                            id: widget.therapistId,
                                            payout: payout,
                                          ),
                                        ),
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColor.hexToColor("#00538C"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          existingPayout == null ? 'Add Payout' : 'Update Payout',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

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
            onTap: () => context.pop(),
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              // Profile Picture
              GestureDetector(
                onTap: () {},
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                    radius: 40,
                    child: Stack(
                      children: [
                        ClipOval(
                          child: CachedNetworkImage(
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            imageUrl: profilePicture,
                            placeholder: (context, url) => const Image(
                              image: AssetImage(AppImage.loadingPlaceholder),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColor.hexToColor("#00538C"),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  widget.userName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              // Profile Section
              Text(
                'Profile',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {},
                      title: Text(
                        "User Name",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
                                  color: AppColor.hexToColor("#73777F"),
                                ),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: AppColor.hexToColor("#73777F"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Email",
                        style: Theme.of(context).textTheme.bodyMedium,
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
                                  color: AppColor.hexToColor("#73777F"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Payout Section
              Text(
                'Payout Details',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: widget.payout == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                color: AppColor.hexToColor("#00538C"),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "No Payout Method",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Add a payout method to receive payments.",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.hexToColor("#73777F"),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () => _showPayoutBottomSheet(context),
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text("Add Payout Method"),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: AppColor.hexToColor("#00538C"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                textStyle: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.account_balance_wallet_outlined,
                              color: AppColor.hexToColor("#00538C"),
                              size: 24,
                            ),
                            title: Text(
                              "Payout Method",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Account Name: ${widget.payout!.accountName}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.hexToColor("#73777F"),
                                  ),
                                ),
                                Text(
                                  "Account Number: ${widget.payout!.accountNumber}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.hexToColor("#73777F"),
                                  ),
                                ),
                                Text(
                                  "Bank Code: ${widget.payout!.bankCode}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.hexToColor("#73777F"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () => _showPayoutBottomSheet(context, existingPayout: widget.payout),
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text("Update Payout"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColor.hexToColor("#00538C"),
                                side: BorderSide(
                                  color: AppColor.hexToColor("#00538C"),
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                textStyle: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
              // Security Section
              Text(
                'Security',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {},
                      title: Text(
                        "Password",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColor.hexToColor("#73777F"),
                      ),
                    ),
                    ListTile(
                      trailing: SvgPicture.asset(
                        AppImage.logoutsvg,
                        color: Colors.red,
                      ),
                      subtitle: Text(
                        "Do you want to logout?",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.hexToColor("#73777F"),
                        ),
                      ),
                      title: Text(
                        'Log out',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                      onTap: () => _showDialog(context),
                    ),
                    ListTile(
                      trailing: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      subtitle: Text(
                        "Your account will be deleted",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColor.hexToColor("#73777F"),
                        ),
                      ),
                      title: Text(
                        'Delete Account',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                      onTap: () => _showDeleteAccountDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocConsumer<DeleteTherapistBloc, DeleteTherapistState>(
          listener: (context, state) {
            if (state is DeleteTherapistLoaded) {
              GoRouter.of(context).go(AppPath.login);
            } else if (state is DeleteTherapistError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: const Text('Delete Account'),
              content: const Text('Are you sure you want to delete your account?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<DeleteTherapistBloc>().add(
                          DeleteTherapistLoadEvent(therapistId: widget.therapistId),
                        );
                  },
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
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
                  onPressed: () => Navigator.of(context).pop(),
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
                ),
              ],
            );
          },
        );
      },
    );
  }
}