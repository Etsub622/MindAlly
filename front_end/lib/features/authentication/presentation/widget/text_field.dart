import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final Widget? sign;
  final int maxLength;
  final bool isPassword;
  const CustomTextField(
      {super.key,
      required this.text,
      required this.controller,
      this.sign,
      this.isPassword = false,
      this.maxLength = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: text,
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
              color: Color(0xff807C8B),
              width: 1,
            ),
          ),
          suffixIcon: sign),
      maxLines: maxLength,
    );
  }
}
