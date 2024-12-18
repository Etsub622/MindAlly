import 'package:flutter/material.dart';
import 'package:front_end/core/confit/app_path.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/onboard_widget.dart';
import 'package:front_end/features/authentication/presentation/widget/scroll.dart';
import 'package:go_router/go_router.dart';

class OnboardOne extends StatelessWidget {
  const OnboardOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            OnboardWidget(
                text: "Skip",
                mainText: " Welcome to MindAlly!",
                subtext: "Your mental health journey starts\n "
                    "here, designed for students like you.",
                image: Image.asset('asset/image/onboard1.webp')),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScrollDesign2(),
                SizedBox(
                  width: 10,
                ),
                ScrollDesign(),
                SizedBox(
                  width: 10,
                ),
                ScrollDesign(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                text: 'Next',
                onPressed: () {
                  context.go(AppPath.onboard2);
                }),
          ],
        ),
      ),
    );
  }
}
