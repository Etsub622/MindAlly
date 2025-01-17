import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/authentication/data/models/professional_signup_model.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/text_field.dart';
import 'package:go_router/go_router.dart';

class ProfessionalSignup extends StatefulWidget {
  const ProfessionalSignup({super.key});

  @override
  State<ProfessionalSignup> createState() => _ProfessionalSignupState();
}

class _ProfessionalSignupState extends State<ProfessionalSignup> {
  final _key = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController areaContloller = TextEditingController();
  final TextEditingController documentController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    areaContloller.dispose();
    documentController.dispose();
    super.dispose();
  }

  void _professionalSignUp(BuildContext context) {
    final newUser = ProfessionalSignupModel(
        id: '',
        email: emailController.text,
        password: passwordController.text,
        fullName: nameController.text,
        phoneNumber: phoneController.text,
        specialization: areaContloller.text,
        document: documentController.text);
    context
        .read<AuthBloc>()
        .add(ProfessionalsignUpEvent(professionalSignupEntity: newUser));
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
        }else if(state is AuthError){
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
                  height: 100,
                  width: 100,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Create your account',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(text: "full name", controller: nameController),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(text: "email", controller: emailController),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    text: "password",
                    sign: Icon(Icons.remove_red_eye),
                    controller: passwordController,
                    isPassword: true),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    text: "confirm password",
                    sign: Icon(Icons.remove_red_eye),
                    controller: confirmPasswordController,
                    isPassword: true),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    text: "Phone Number", controller: phoneController),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    text: "Area of Specialization", controller: areaContloller),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    text: "Certified document", controller: documentController),
                SizedBox(
                  height: 40,
                ),
                CustomButton(
                  wdth: double.infinity,
                  rad: 10,
                  hgt: 50,
                  text: "Sign Up",
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      if (passwordController.text ==
                          confirmPasswordController.text) {
                        _professionalSignUp(context);
                      } else {
                        final snack = errorsnackBar('Password does not match');
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 15,
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
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Color(0xffB57EDC),
                              fontSize: 12,
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
