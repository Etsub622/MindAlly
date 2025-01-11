import 'package:flutter/material.dart';

class OnboardWidget extends StatelessWidget {
  final String? text;
  final String mainText;
  final Image image;
  final String subtext;

  const OnboardWidget({
    super.key,
    this.text,
    required this.mainText,
    required this.image,
    required this.subtext,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              right: 10,
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                text ?? '',
                style: const TextStyle(
                  color: Color(0xffB57EDC),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xffB57EDC),
                  decorationThickness: 2,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 400,
            width: double.infinity,
            child: image,
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Text(
                mainText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 10.0, top: 3),
              child: Text(
                subtext,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
