import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/features/authentication/presentation/widget/role_widget.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final double wdth;
  final double hgt;
  final double rad;
  final Color color;
  final Image? icon;
  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.wdth = 360,
      this.rad = 30,
      this.icon,
      this.color = const Color(0xFFB57EDC),
      this.hgt = 40});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: wdth,
        height: hgt,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rad),
          color: color,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 8.w),
              ],
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
