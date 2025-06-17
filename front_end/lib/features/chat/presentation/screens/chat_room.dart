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
    DateTime parsedDate = DateTime.parse(timeStamp).toLocal();
    return DateFormat('HH:mm').format(parsedDate);
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
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary.withOpacity(0.9),
          Theme.of(context).colorScheme.secondary.withOpacity(0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
    ),
  ),
  title: const SafeArea(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 8),
          Text(
            "Chats",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  ),
  centerTitle: true, // Ensures the title is centered
  toolbarHeight: 80, // Adjust height for better appearance
  elevation: 0, // Optional: Remove shadow for a cleaner look
),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatListBloc, ChatListState>(
                  builder: (context, state) {
                    if (state is GetAllChatsState) {
                      if (state.status == ChatStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.status == ChatStatus.success) {
                        ListChatsEntity chatsList = state.chats;
                        List<ChatsEntity> chats = chatsList.chats;

                        if (chats.isEmpty) {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.all(24),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "asset/image/no_chat_history.png",
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No Chat History",
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[900],
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "It seems you haven't had any conversations yet",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[700],
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: GestureDetector(
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
                                child: Card(
                                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  color: Colors.blue[50]!,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                       chats[index].receiver.profilePicture ?? "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
                                      ),
                                      backgroundColor: Colors.grey[200],
                                    ),
                                    title: Text(
                                      chats[index].receiver.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      chats[index].lastMessage,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Colors.grey[700],
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                      formateTimeStamp(chats[index].lastMessageTime),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state.status == ChatStatus.error) {
                        return Center(
                          child: Text(
                            'Error loading chats',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.red[700],
                                ),
                          ),
                        );
                      }
                    }
                    return Center(
                      child: Text(
                        'Unexpected state',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}