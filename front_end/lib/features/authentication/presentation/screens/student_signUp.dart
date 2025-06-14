import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/authentication/data/models/student_signup_model.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
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
  final TextEditingController emergencyNumberController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    emergencyNumberController.dispose();
    college.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$')
        .hasMatch(value)) {
      return 'Password must contain letters, numbers, and a special character';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const CircularIndicator();
          } else {
            return _buildForm(context);
          }
        },
        listener: (context, state) {
          if (state is AuthOtpSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP sent to your email.')),
            );
            final student = StudentSignupModel(
              id: '',
              email: emailController.text,
              password: passwordController.text,
              fullName: nameController.text,
              phoneNumber: phoneController.text,
              EmergencyEmail: emergencyNumberController.text,
              collage: college.text,
            );
            context.go(
              AppPath.otp,
              extra: {
                'email': emailController.text,
                'verificationType': 'studentSignup',
                'student': student,
              },
            );
          } else if (state is AuthOtpSendError) {
            final snack = errorsnackBar(
                state.message ?? 'Failed to send OTP. Try again.');
            ScaffoldMessenger.of(context).showSnackBar(snack);
          } else if (state is AuthSuccess) {
            final snack = snackBar('User created successfully');
            ScaffoldMessenger.of(context).showSnackBar(snack);
            Future.delayed(const Duration(seconds: 2), () {
              context.go(AppPath.login);
            });
          } else if (state is AuthError) {
            final snack = errorsnackBar(state.message ?? 'Try again later');
            ScaffoldMessenger.of(context).showSnackBar(snack);
          }
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Padding(
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
                  const SizedBox(height: 28),
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomTextField(
                    key: const ValueKey('full_name_field'),
                    text: "Full Name",
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    key: const ValueKey('email_field'),
                    text: "Email",
                    controller: emailController,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    key: const ValueKey('password_field'),
                    text: "Password",
                    controller: passwordController,
                    isPassword: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    key: const ValueKey('confirm_password_field'),
                    text: "Confirm Password",
                    controller: confirmPasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    key: const ValueKey('phone_field'),
                    text: "Phone Number",
                    controller: phoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    key: const ValueKey('emergency_email'),
                    text: "Emergency Email",
                    controller: emergencyNumberController,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    key: const ValueKey('college_field'),
                    text: "College",
                    controller: college,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'College is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    key: const ValueKey('sign_up_button'),
                    wdth: double.infinity,
                    rad: 10,
                    hgt: 50,
                    text: "Sign Up",
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            errorsnackBar('Passwords do not match!'),
                          );
                          return;
                        }
                        context.read<AuthBloc>().add(
                              SendOtpEvent(email: emailController.text),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      key: const ValueKey('login_redirect'),
                      onTap: () {
                        context.go(AppPath.patientOnboard);
                      },
                      child: RichText(
                        text: const TextSpan(
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
      ),
    );
  }
}
