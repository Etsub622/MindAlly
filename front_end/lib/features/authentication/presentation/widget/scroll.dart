import 'package:flutter/material.dart';

class ScrollDesign extends StatelessWidget {
  const ScrollDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 15,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Color(0xffB57EDC), width: 1)),
    );
  }
}

class ScrollDesign2 extends StatelessWidget {
  const ScrollDesign2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 25,
      decoration: BoxDecoration(
        color: Color(0xffB57EDC),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}

class ScrollDesignFinal extends StatelessWidget {
  final Widget design;
  const ScrollDesignFinal({super.key, required this.design});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          design,
          SizedBox(
            width: 10,
          ),
          design,
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 10,
          ),
          design,
        ],
      ),
    );
  }
}