import 'package:flutter/material.dart';
import 'package:front_end/features/Home/presentation/screens/home_app_bar.dart';
import 'package:front_end/features/chat/presentation/screens/chat_bot_room.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarHome(context: context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Screen!'),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showChatBot(context);
        },
        child: Image.asset("asset/image/chatbot_icon.png"),
      ),
    );
  }

  void _showChatBot(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible:false,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const ChatBotScreen(),
        );
      },
    );
  }
}



