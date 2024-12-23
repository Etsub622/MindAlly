import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/core/confit/app_path.dart';
import 'package:front_end/features/authentication/data/models/student_signup_model.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/role_widget.dart';
import 'package:front_end/features/authentication/presentation/widget/text_field.dart';
import 'package:go_router/go_router.dart';

class StudentSignUp extends StatefulWidget {
  const StudentSignUp({super.key});

  @override
  State<StudentSignUp> createState() => _StudentSignUpState();
}

class _StudentSignUpState extends State<StudentSignUp> {
  final _key = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController college = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    college.dispose();
    super.dispose();
  }

  void _studentSignUP(BuildContext context) {
    final newUser = StudentSignupModel(
        id: '',
        email: emailController.text,
        password: passwordController.text,
        fullName: nameController.text,
        phoneNumber: phoneController.text,
        college: college.text);
    context
        .read<AuthBloc>()
        .add(StudentsignUpEvent(studentSignupEntity: newUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer(builder: (context, state) {
        if (state is AuthLoading) {
          return CircularIndicator();
        } else {
          return _build(context);
        }
      }, listener: (context, state) {
        if (state is AuthSuccess) {
          final snack = snackBar('User created successfully');
          ScaffoldMessenger.of(context).showSnackBar(snack);

          Future.delayed(const Duration(seconds: 2), () {
            context.go(AppPath.login);
          });
        } else if (state is AuthError) {
          final snack = errorsnackBar('Try again later');
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
      }),
    );
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _key,
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
                  'Create your account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                CustomTextField(text: "full name", controller: nameController),
                SizedBox(
                  height: 20.h,
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
                  height: 20.h,
                ),
                CustomTextField(
                    text: "confirm password",
                    sign: Icon(Icons.remove_red_eye),
                    controller: confirmPasswordController,
                    isPassword: true),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(
                    text: "Phone Number", controller: phoneController),
                SizedBox(
                  height: 20.h,
                ),
                CustomTextField(text: "College(Optional)", controller: college),
                SizedBox(
                  height: 40.h,
                ),
                CustomButton(
                    wdth: double.infinity,
                    rad: 10,
                    hgt: 50,
                    text: "Sign Up",
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              errorsnackBar('Password does not match'));
                          _studentSignUP(context);
                        }
                      }
                    }),
                SizedBox(
                  height: 15.h,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      context.go(AppPath.login);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Color(0xffB57EDC),
                              fontSize: 12.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
