import 'package:flutter/material.dart';
import 'package:front_end/features/resource/presentation/screens/article_resource.dart';
import 'package:front_end/features/resource/presentation/screens/book_resource.dart';
import 'package:front_end/features/resource/presentation/screens/video_resource.dart';
import 'package:front_end/features/resource/presentation/widget/toggle_button.dart';

class ResourceRoom extends StatefulWidget {
  const ResourceRoom({super.key});

  @override
  State<ResourceRoom> createState() => _ResourceRoomState();
}

class _ResourceRoomState extends State<ResourceRoom> {
  List<bool> isSelected = [true, false, false];

  Widget _getSelectedPage() {
    if (isSelected[0]) {
      return const ArticleResource();
    } else if (isSelected[1]) {
      return const VideoResource();
    } else {
      return const BookResource();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Room'),
      ),
      body: Column(
        children: [
          CustomToggleButton(
            isSelected: isSelected,
            onToggle: (idx) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == idx;
                }
              });
            },
          ),
          Expanded(
            child: _getSelectedPage(),
          ),
        ],
      ),
    );
  }
}
