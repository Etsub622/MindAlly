import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/confit/app_path.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                  GoRouter.of(context).go(AppPath.forgotPassword);
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
