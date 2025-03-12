import 'package:front_end/features/chat/domain/entities/chats_entity.dart';
import 'package:front_end/features/chat/domain/entities/list_chats_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import 'package:front_end/features/chat/presentation/screens/chat_page.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}
class _ChatRoomState extends State<ChatRoom> {
  String formateTimeStamp(String timeStamp) {
    DateTime parsedDate = DateTime.parse(timeStamp).toUtc();
    return DateFormat('hh:mm a').format(parsedDate);
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatListBloc>().add(GetAllChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state is GetAllChatsState) {
            if (state.status == ChatStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == ChatStatus.success) {
              ListChatsEntity chatsList = state.chats;
              List<ChatsEntity> chats = chatsList.chats;

              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatId: chats[index].chatId,
                            receiver: chats[index].receiver,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.002,
                        horizontal: MediaQuery.of(context).size.width * 0.002,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ListTile(
                        title: Text(chats[index].receiver.name),
                        subtitle: Text(chats[index].lastMessage),
                        trailing: Text(chats[index].lastMessageTime),
                        leading: CircleAvatar(
                          radius: MediaQuery.of(context).size.height * 0.06,
                          backgroundImage: const NetworkImage(
                              "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg"),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.status == ChatStatus.error) {
              return const Center(child: Text('Error loading chats'));
            }
          }
          return const Center(child: Text('Unexpected state'));
        },
      ),
    );
  }
}