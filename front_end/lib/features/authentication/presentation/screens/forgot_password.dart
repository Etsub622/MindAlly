import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/core/confit/app_path.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/text_field.dart';
import 'package:go_router/go_router.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  void _sentOtp(BuildContext context) {
    final email = emailController.text;

    context.read<AuthBloc>().add(SendOtpEvent(email: email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        } else {
          return _buildForm(context);
        }
      }, listener: (context, state) {
        if (state is AuthOtpSent) {
          const snack = SnackBar(content: Text('OTP is sent to your email.'));
          ScaffoldMessenger.of(context).showSnackBar(snack);

          context.go(AppPath.otp, extra: emailController.text);
        } else if (state is AuthOtpSendError) {
          final snack = errorsnackBar('Try again');
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
                'Forgot Password ?',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                'Enter your email address below to reset your password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 45.h,
              ),
              CustomTextField(text: "email", controller: emailController),
              SizedBox(
                height: 5.h,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    context.go(AppPath.role);
                  },
                  child: Text('Remember password?',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              CustomButton(
                wdth: double.infinity,
                rad: 10,
                hgt: 50.h,
                text: "Send",
                onPressed: () {
                  _sentOtp(context);
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
