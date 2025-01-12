


import 'package:flutter/material.dart';

class ResourceRoom extends StatefulWidget {
  const ResourceRoom({super.key});

  @override
  State<ResourceRoom> createState() => _ResourceRoomState();
}

class _ResourceRoomState extends State<ResourceRoom> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome to Resources :)'),
      ),
    );
  }
}