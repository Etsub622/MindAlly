import 'package:flutter/material.dart';

class VideoResource extends StatefulWidget {
  const VideoResource({super.key});

  @override
  State<VideoResource> createState() => _VideoResourceState();
}

class _VideoResourceState extends State<VideoResource> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome to video Resources :)'),
      ),
    );
  }
}