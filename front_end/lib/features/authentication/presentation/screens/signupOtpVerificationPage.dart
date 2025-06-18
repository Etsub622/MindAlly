// lib/features/authentication/presentation/pages/signup_otp_verification.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/common_widget.dart/circular_indicator.dart';
import 'package:front_end/core/common_widget.dart/snack_bar.dart';
import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

class SignupOtpVerificationPage extends StatefulWidget {
  final String email;
  final Map<String, dynamic> userData;
  final String role; // 'patient' or 'therapist'

  const SignupOtpVerificationPage({
    super.key,
    required this.email,
    required this.userData,
    required this.role,
  });

  @override
  State<SignupOtpVerificationPage> createState() =>
      _SignupOtpVerificationPageState();
}

class _SignupOtpVerificationPageState extends State<SignupOtpVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _baseUrl = '${ConfigKey.baseUrl}/auth';

  @override
  void initState() {
    super.initState();
    _sendOtp(); 
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar('OTP sent to ${widget.email}'),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          errorsnackBar(data['message'] ?? 'Failed to send OTP'),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorsnackBar('Network error: $e'),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtpAndSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // Verify OTP
      final otpResponse = await http.post(
        Uri.parse('$_baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp': otpController.text,
        }),
      );

      final otpData = jsonDecode(otpResponse.body);
      if (otpResponse.statusCode != 200 || !otpData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          errorsnackBar(otpData['message'] ?? 'Invalid OTP'),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Complete signup
      final signupUrl = widget.role == 'patient'
          ? '$_baseUrl/PatientSignup'
          : '$_baseUrl/therapistSignup';
      final signupResponse = await http.post(
        Uri.parse(signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(widget.userData),
      );

      final signupData = jsonDecode(signupResponse.body);
      if (signupResponse.statusCode == 201 &&
          signupData['message'] == 'Patient created successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar('Account created successfully'),
        );
        Future.delayed(const Duration(seconds: 2), () {
          context.go(AppPath.login);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          errorsnackBar(signupData['message'] ?? 'Signup failed'),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorsnackBar('Network error: $e'),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const CircularIndicator()
          : SafeArea(
              child: Material(
                child: Padding(
                  padding: EdgeInsets.all(15.w),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/image/logo.webp',
                            height: 100.h,
                            width: 100.w,
                          ),
                          SizedBox(height: 28.h),
                          const Text(
                            'Verify Your Email',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Enter the 4-digit OTP sent to ${widget.email}',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 28.h),
                          PinCodeTextField(
                            appContext: context,
                            length: 4,
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(8.r),
                              fieldHeight: 50.h,
                              fieldWidth: 50.w,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.grey[100],
                              selectedFillColor: Colors.white,
                              activeColor: const Color(0xFFB57EDC),
                              inactiveColor: Colors.grey[300],
                              selectedColor: const Color(0xFFB57EDC),
                            ),
                            enableActiveFill: true,
                            validator: (value) {
                              if (value == null || value.length != 4) {
                                return 'Enter a 4-digit OTP';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          CustomButton(
                            wdth: double.infinity,
                            rad: 10,
                            hgt: 50.h,
                            text: 'Verify OTP',
                            onPressed: _verifyOtpAndSignup,
                          ),
                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: _isLoading ? null : _sendOtp,
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                color: Color(0xFFB57EDC),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
