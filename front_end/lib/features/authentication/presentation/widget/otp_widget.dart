import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  const OtpWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      width: 50.w,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color(0xffB57EDC),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Color(0xffB57EDC),
              width: 1,
            ),
          ),
          counterText: '',
        ),
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.sp,
          color: Color(0xffB57EDC),
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        onChanged: (value) {
          if (value.length == 1) {
            nextFocusNode?.requestFocus();
          }
        },
      ),
    );
  }
}
