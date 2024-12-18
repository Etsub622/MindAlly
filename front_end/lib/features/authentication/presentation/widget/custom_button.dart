import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final double wdth;
  final double hgt;
  final double rad;
  final Color color;
  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.wdth = 360,
      this.rad = 30,
      this.color = const Color(0xFFB57EDC),
      this.hgt = 40});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: wdth,
        height: hgt,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rad),
          color: color,
        ),
      ),
    );
  }
}
