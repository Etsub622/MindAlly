

import 'package:flutter/material.dart';

class QARoom extends StatefulWidget {
  const QARoom({super.key});

  @override
  State<QARoom> createState() => _QARoomState();
}

class _QARoomState extends State<QARoom> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome to QA :)'),
      ),
    );
  }
}