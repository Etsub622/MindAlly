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
  final TextEditingController _searchController = TextEditingController();
  List<bool> isSelected = [true, false, false];

  Widget _getSelectedPage() {
    if (isSelected[0]) {
      return const BookResource();
    } else if (isSelected[1]) {
      return const VideoResource();
    } else {
      return const ArticleResource();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child:  Padding(
            padding:  EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.top * 0.3, left: MediaQuery.of(context).size.width * 0.02, right: MediaQuery.of(context).size.width * 0.02),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for books, videos, articles',
                hintStyle: TextStyle(color: Color(0xff08E0EEA)),
                prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                filled: true,
                fillColor: Color.fromARGB(255, 226, 225, 225),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
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
