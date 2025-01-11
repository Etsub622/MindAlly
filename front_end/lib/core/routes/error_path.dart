// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatefulWidget {
  final String message;

  const ErrorPage({super.key, required this.message});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  void redirect() {
    context.go(AppPath.home);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0), () {
      redirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset('assets/images/logo_dark.png'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go(AppPath.home);
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
