import 'package:flutter/material.dart';
import 'package:front_end/core/confit/app_path.dart';
import 'package:front_end/features/authentication/presentation/widget/custom_button.dart';
import 'package:front_end/features/authentication/presentation/widget/onboard_widget.dart';
import 'package:front_end/features/authentication/presentation/widget/scroll.dart';
import 'package:go_router/go_router.dart';

class OnboardThree extends StatelessWidget {
  const OnboardThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            OnboardWidget(
                mainText: "Join our community",
                subtext: "Join our community and unlock resources that inspire "
                    "and support your mental wellness journey.",
                image: Image.asset('asset/image/onb3.webp')),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScrollDesign(),
                SizedBox(
                  width: 10,
                ),
                ScrollDesign(),
                SizedBox(
                  width: 10,
                ),
                ScrollDesign2(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                text: 'Get Started',
                onPressed: () {
                  context.go(AppPath.role);
                }),
          ],
        ),
      ),
    );
  }
}
