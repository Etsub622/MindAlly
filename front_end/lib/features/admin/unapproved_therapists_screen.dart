import 'package:flutter/material.dart';

class UnapprovedTherapistsScreen extends StatefulWidget {
  const UnapprovedTherapistsScreen({super.key});

  @override
  State<UnapprovedTherapistsScreen> createState() => _UnapprovedTherapistsScreenState();
}

class _UnapprovedTherapistsScreenState extends State<UnapprovedTherapistsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unapproved Therapists')),
      body: const Center(
        child: Text('List of unapproved therapists will be displayed here.'),
      ),
    );
  }
}