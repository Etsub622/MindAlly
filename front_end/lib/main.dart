import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:front_end/core/confit/router_config.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_one.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_three.dart';
import 'package:front_end/features/authentication/presentation/screens/onboard_two.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(MyApp(router: AppRouter.router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return ScreenUtilInit(
          designSize: const Size(360, 800),
          builder: (BuildContext context, Widget? child) {
            return MaterialApp.router(
              routerConfig: router,
              title: 'MindAlly',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffB57EDC)),
                useMaterial3: true,
              ),
            );
          },
        );
      },
    );
  }
}
