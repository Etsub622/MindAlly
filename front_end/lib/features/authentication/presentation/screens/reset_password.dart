import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/core/confit/app_path.dart';
import 'package:front_end/features/authentication/data/models/reset_password_model.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/text_field.dart';
import 'package:go_router/go_router.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

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

  void resetPassword(BuildContext context) {
    final resetPassword = ResetPasswordModel(
      id: '',
      password: passwordController.text,
    );
    context
        .read<AuthBloc>()
        .add(ResetPasswordEvent(resetPasswordEntity: resetPassword));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthInitial) {
          return CircularProgressIndicator();
        } else {
          return _buildForm(context);
        }
      }, listener: (context, state) {
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
      }),
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
                height: 100.h,
                width: 100.w,
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                'Set new Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              CustomTextField(
                  text: "password",
                  sign: Icon(Icons.remove_red_eye),
                  controller: passwordController,
                  isPassword: true),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                  text: "confirm password",
                  sign: Icon(Icons.remove_red_eye),
                  controller: confirmPasswordController,
                  isPassword: true),
              SizedBox(
                height: 40.h,
              ),
              CustomButton(
                wdth: double.infinity,
                rad: 10,
                hgt: 50.h,
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
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
