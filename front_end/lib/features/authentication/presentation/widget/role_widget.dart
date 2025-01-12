import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/main.dart';

class RoleWidget extends StatelessWidget {
  final String text;
  final Image image;
  final Color color;
  final void Function() onPressed;
  const RoleWidget(
      {super.key,
      required this.image,
      required this.text,
      required this.onPressed,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 180,
        width: 352,
        child: Card(
          color: color,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Color(0xffB57EDC),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Expanded(child: image),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
