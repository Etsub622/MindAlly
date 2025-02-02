import 'package:flutter/material.dart';
import 'package:front_end/features/resource/presentation/screens/add_article.dart';
import 'package:front_end/features/resource/presentation/screens/add_book.dart';
import 'package:front_end/features/resource/presentation/screens/add_video.dart';

class VideoResource extends StatefulWidget {
  const VideoResource({super.key});

  @override
  State<VideoResource> createState() => _VideoResourceState();
}

class _VideoResourceState extends State<VideoResource> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome to video Resources :)'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVideo()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
