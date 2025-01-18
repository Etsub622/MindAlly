import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/authentication/data/datasource/auth_local_datasource/login_local_datasource.dart';
import 'package:front_end/features/authentication/data/models/reset_password_model.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  final String resetToken;
  const ResetPassword({super.key, required this.resetToken});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("Received reset token: ${widget.resetToken}");
  }

  void resetPassword(BuildContext context) {
    final reset = ResetPasswordModel(
      resetToken: widget.resetToken,
      newPassword: passwordController.text,
    );
    print('token:${widget.resetToken}');

    context
        .read<AuthBloc>()
        .add(ResetPasswordEvent(resetPasswordEntity: reset));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthInitial || state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildForm(context);
          }
        },
        listener: (context, state) {
          print('Current state: $state');
          if (state is ResetPasswordSuccess) {
            final snack = snackBar('Password reset successfully');
            ScaffoldMessenger.of(context).showSnackBar(snack);

            Future.delayed(const Duration(seconds: 2), () {
              context.go(AppPath.login);
            });
          } else if (state is ResetPasswordError) {
            final snack = errorsnackBar('Try again later');
            ScaffoldMessenger.of(context).showSnackBar(snack);
          }
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 150),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/image/logo.webp',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 30),
              const Text(
                'Set new Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                text: "password",
                sign: const Icon(Icons.remove_red_eye),
                controller: passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                text: "confirm password",
                sign: const Icon(Icons.remove_red_eye),
                controller: confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 40),
              CustomButton(
                wdth: double.infinity,
                rad: 10,
                hgt: 50,
                text: "Set Password",
                onPressed: () {
                  if (passwordController.text ==
                      confirmPasswordController.text) {
                    resetPassword(context);
                  } else {
                    final snack = errorsnackBar('Password does not match');
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
