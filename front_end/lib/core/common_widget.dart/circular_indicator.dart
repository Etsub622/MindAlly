import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        child: const Center(
          child: CircularProgressIndicator(
            color: (Color(0xff800080)),
          ),
        ),
      ),
    );
  }
}
