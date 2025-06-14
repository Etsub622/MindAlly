import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/data/models/professional_signup_model.dart';
import 'package:front_end/features/authentication/data/models/student_signup_model.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/otp_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end/core/routes/app_path.dart';

class OtpVerification extends StatefulWidget {
  final String email;
  final String verificationType;
  final StudentSignupModel? student;
  final ProfessionalSignupModel? professional;
  const OtpVerification({
    super.key,
    required this.email,
    required this.verificationType,
    this.student,
    this.professional,
  });

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();
  final TextEditingController num3Controller = TextEditingController();
  final TextEditingController num4Controller = TextEditingController();

  final FocusNode num1Focus = FocusNode();
  final FocusNode num2Focus = FocusNode();
  final FocusNode num3Focus = FocusNode();
  final FocusNode num4Focus = FocusNode();

  @override
  void initState() {
    super.initState();
    print('Received email: ${widget.email}');
  }

  void _verifyOtp(BuildContext context) {
    final otp = num1Controller.text +
        num2Controller.text +
        num3Controller.text +
        num4Controller.text;
    context.read<AuthBloc>().add(VerifyOtpEvent(
          otp: otp,
          email: widget.email,
          verificationType: widget.verificationType,
        ));
        print( 'Verifying OTP: $otp for email: ${widget.email} with type: ${widget.verificationType}');
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
          if (state is AuthOtpVerified) {
            const snack = SnackBar(content: Text('OTP verified successfully.'));
            ScaffoldMessenger.of(context).showSnackBar(snack);

            if (widget.verificationType == 'forgotPassword') {
              context.go(AppPath.resetPassword,
                  extra: {'resetToken': state.resetToken});
            } else if (widget.verificationType == 'studentSignup') {
              if (widget.student == null) {
                final snack = errorsnackBar('Student data is missing.');
                ScaffoldMessenger.of(context).showSnackBar(snack);
                context.go(AppPath.student);
                return;
              }
              context.read<AuthBloc>().add(
                  StudentsignUpEvent(studentSignupEntity: widget.student!));
            } else if (widget.verificationType == 'professionalSignup') {
              if (widget.professional == null) {
                final snack = errorsnackBar('Professional data is missing.');
                ScaffoldMessenger.of(context).showSnackBar(snack);
                context.go(AppPath.professional);
                return;
              }
              context.read<AuthBloc>().add(ProfessionalsignUpEvent(
                  professionalSignupEntity: widget.professional!));
            } else {
              final snack = errorsnackBar('Unknown verification type.');
              ScaffoldMessenger.of(context).showSnackBar(snack);
            }
          } else if (state is AuthOtpVerifyError) {
            final snack = errorsnackBar('Enter a valid OTP');
            ScaffoldMessenger.of(context).showSnackBar(snack);
          } else if (state is AuthSuccess) {
            String message;
            if (widget.verificationType == 'studentSignup') {
              message = 'User created successfully';
            } else if (widget.verificationType == 'professionalSignup') {
              message =
                  'Account created successfully! Your documents will be reviewed before full access.';
            } else {
              message = 'User created successfully';
            }
            final snack = snackBar(message);
            ScaffoldMessenger.of(context).showSnackBar(snack);

            Future.delayed(const Duration(seconds: 2), () {
              if (widget.verificationType == 'studentSignup') {
                context.go(AppPath.login);
              } else if (widget.verificationType == 'professionalSignup') {
                context.go(AppPath.therapistOnboard);
              }
            });
          } else if (state is AuthError) {
            final snack = errorsnackBar(
                state.message ?? 'Signup failed. Please try again.');
            ScaffoldMessenger.of(context).showSnackBar(snack);
            if (widget.verificationType == 'studentSignup') {
              context.go(AppPath.student, extra: widget.student?.toJson());
            } else if (widget.verificationType == 'professionalSignup') {
              context.go(AppPath.professional,
                  extra: widget.professional?.toJson());
            }
          }
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
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
                'Enter your OTP code',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OtpWidget(
                    controller: num1Controller,
                    focusNode: num1Focus,
                    nextFocusNode: num2Focus,
                  ),
                  const SizedBox(width: 15),
                  OtpWidget(
                    controller: num2Controller,
                    focusNode: num2Focus,
                    nextFocusNode: num3Focus,
                  ),
                  const SizedBox(width: 15),
                  OtpWidget(
                    controller: num3Controller,
                    focusNode: num3Focus,
                    nextFocusNode: num4Focus,
                  ),
                  const SizedBox(width: 15),
                  OtpWidget(
                    controller: num4Controller,
                    focusNode: num4Focus,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              CustomButton(
                wdth: double.infinity,
                rad: 10,
                hgt: 50,
                text: "Verify",
                onPressed: () {
                  _verifyOtp(context);
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  context
                      .read<AuthBloc>()
                      .add(SendOtpEvent(email: widget.email));
                },
                child: const Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: Color(0xffB57EDC),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
