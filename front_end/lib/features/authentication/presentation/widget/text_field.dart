import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final Widget? sign;
  final int maxLength;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField(
      {super.key,
      required this.text,
      required this.controller,
      this.sign,
      this.isPassword = false,
      this.maxLength = 1,
      this.validator});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: widget.text,
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
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      maxLines: 1,
      validator: widget.validator,
    );
  }
}
