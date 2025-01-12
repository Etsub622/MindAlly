import 'package:flutter/material.dart';
import 'package:front_end/core/utils/constants.dart';
import 'package:front_end/features/Home/presentation/screens/home_screen.dart';
import 'package:front_end/features/chat/presentation/screens/chat_room.dart';
import 'package:front_end/features/qa/presentation/screens/qa_room.dart';
import 'package:front_end/features/resource/presentation/screens/resource_room.dart';

class HomeNavigationScreen extends StatefulWidget {
  final int index;

  const HomeNavigationScreen({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  int index = 0;
  final screens = [
    const HomeScreen(),
    const QARoom(),
    const ResourceRoom(),
    const ChatRoom(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [screens[index]],
        ),
      ),
      bottomNavigationBar: ClipRect(
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: index,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          unselectedLabelStyle: TextStyle(color: Colors.white),
          selectedLabelStyle: TextStyle(color: Colors.white),
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              this.index = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: index == 0 ? Image.asset(AppImage.homeUnselected): Image.asset(AppImage.homeUnselected), 
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: index == 1 ?  Image.asset(
                AppImage.qaUnselected,
              ): Image.asset(
                AppImage.qaUnselected,
              ), 
              label: 'Q&A',
            ),
            BottomNavigationBarItem(
              icon: index== 2 ? Image.asset(
                AppImage.resourceUnselected,
              ): Image.asset(
                AppImage.resourceUnselected,
              ), 
              label: 'Resource',
            ),
            BottomNavigationBarItem(
              icon: index == 3 ? Image.asset(
                AppImage.chatSelected,
              ) : Image.asset(
                AppImage.chatSelected,
              ), 
              label: 'Chat',
            ),
          ],
        ),
      ),
    );
  }
}
