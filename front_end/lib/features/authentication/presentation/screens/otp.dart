import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/confit/app_path.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/otp_widget.dart';
import 'package:go_router/go_router.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

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
                'Enter your OTP code',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 30.h,
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
                    width: 15.h,
                  ),
                  OtpWidget(
                    controller: num2Contoller,
                    focusNode: num2Focus,
                    nextFocusNode: num3Focus,
                  ),
                  SizedBox(
                    width: 15.h,
                  ),
                  OtpWidget(
                    controller: num3Controller,
                    focusNode: num3Focus,
                    nextFocusNode: num4Focus,
                  ),
                  SizedBox(
                    width: 15.h,
                  ),
                  OtpWidget(
                    controller: num4Controller,
                    focusNode: num4Focus,
                  ),
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              CustomButton(
                wdth: double.infinity,
                rad: 10,
                hgt: 50.h,
                text: "Verify",
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
