import 'package:front_end/features/Home/presentation/screens/home_navigation_screen.dart';
import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/single_chat_entity.dart';
import 'package:front_end/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:front_end/features/chat/presentation/widgets/chat_bubble_widget.dart';
import 'package:front_end/features/chat/presentation/widgets/chat_write_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatId;
  final ChatsEntity chatInfo;
  const ChatDetailScreen({super.key, required this.chatId, required this.chatInfo});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetSingleChatEvent(chatId: widget.chatId));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomeNavigationScreen(
                      index:3,
                    ),
                  ),
                );
          },
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg"),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.chatInfo.chatName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
      bloc: context.read<ChatBloc>(),
      builder: (context, state) {
        if( state is GetSingleChatState){
          if(state.status == ChatStatus.loading){
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ChatStatus.success){
            List<SingleChatEntity> chats = state.chats ?? [];
            return Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () { },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.002,
                      ),
                      child: ChatBubbleWidget(
                          message: chats[index].message,
                          isMe: chats[index].senderId == "user_001",
                          dataType: chats[index].dataType,
                          dataUrl: chats[index].dataUrl),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: ChatWriteBoxWidget(
              onSend: (message) {
                setState(() {
                  context.read<ChatBloc>().add(SendChatEvent(
                      message: message,
                      chatId: widget.chatId,
                      senderId: "user_001",
                      receiverId: "user_002"));
                });
              },
            ),
          )
        ],
      );     
      }
          else if (state.status == ChatStatus.error){
            return const Center(
              child: Text("Error"),
            );
          }
        }
        return Container();
      },
    ));
}
}
