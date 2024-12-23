import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/confit/app_path.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/text_field.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController college = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 50),
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
                'Log in to your account',
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
              CustomTextField(text: "email", controller: emailController),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                  text: "password",
                  sign: Icon(Icons.remove_red_eye),
                  controller: passwordController,
                  isPassword: true),
              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {

                    context.go(AppPath.forgotPassword);
                  },
                  child: Text('Forgot password?',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      )),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              CustomButton(
                wdth: double.infinity,
                rad: 10,
                hgt: 50.h,
                text: "Log In",
                onPressed: () {
                  context.go(AppPath.otp);
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    context.go(AppPath.role);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account yet? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: 'SignUp',
                          style: TextStyle(
                            color: Color(0xffB57EDC),
                            fontSize: 11.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              Text(
                'Or continue with',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                rad: 10,
                wdth: double.infinity,
                hgt: 50.h,
                text: 'Log in with Google',
                onPressed: () {},
                icon: Image.asset(
                  'asset/image/student.png',
                  height: 40,
                  width: 40,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
