import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/otp_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:front_end/core/routes/app_path.dart';

class OtpVerification extends StatefulWidget {
  final String email;
  const OtpVerification({super.key, required this.email});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController num1Conttroller = TextEditingController();
  final TextEditingController num2Contoller = TextEditingController();
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
    final otp = num1Conttroller.text +
        num2Contoller.text +
        num3Controller.text +
        num4Controller.text;
    context.read<AuthBloc>().add(VerifyOtpEvent(otp: otp, email: widget.email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularIndicator();
        } else {
          return _buildForm(context);
        }
      }, listener: (context, state) {
        if (state is AuthOtpVerified) {
          const snack = SnackBar(content: Text('OTP verified successfully.'));
          ScaffoldMessenger.of(context).showSnackBar(snack);
          context.go(AppPath.resetPassword,extra: {'resetToken':state.resetToken});
        } else if (state is AuthOtpVerifyError) {
          final snack = errorsnackBar('Enter the valid otp');
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
                height: 100,
                width: 100,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Enter your OTP code',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OtpWidget(
                    controller: num1Conttroller,
                    focusNode: num1Focus,
                    nextFocusNode: num2Focus,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  OtpWidget(
                    controller: num2Contoller,
                    focusNode: num2Focus,
                    nextFocusNode: num3Focus,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  OtpWidget(
                    controller: num3Controller,
                    focusNode: num3Focus,
                    nextFocusNode: num4Focus,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  OtpWidget(
                    controller: num4Controller,
                    focusNode: num4Focus,
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              CustomButton(
                wdth: double.infinity,
                rad: 10,
                hgt: 50,
                text: "Verify",
                onPressed: () {
                  _verifyOtp(context);
                },
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
