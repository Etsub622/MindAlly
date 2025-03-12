import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:front_end/features/chat/data/models/single_chat_model.dart';
import 'package:front_end/features/chat/domain/entities/message_entity.dart';
import 'package:front_end/features/profile/domain/entities/user_entity.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final UserEntity receiver;
  const ChatPage({super.key, required this.chatId, required this.receiver});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  String userId = "";

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatBloc>(context).add(LoadMessagesEvent(chatId: widget.chatId));
    fetchUserId();
  }

  fetchUserId() async {
    final userCredential = await _storage.read(key: "user_profile") ?? '';

    final body = await json.decode(userCredential);
    userId = body["_id"].toString();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(SendChatEvent(
        messageModel: MessageModel(
          chatId: widget.chatId, 
          message: message,
          senderId: userId, 
          timestamp: DateTime.now(), 
          isRead: false, 
          receiverId: widget.receiver.id)
      ));
      _messageController.clear();
    }
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg"
                  )),
             const SizedBox(
                width: 10,
              ),
              Text(
                widget.receiver.name,
              style: Theme.of(context).textTheme.titleMedium
              ),

          ],
        ),
        backgroundColor:Colors.transparent,
        elevation: 0,

      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if(state is ChatLoadingState){
                  return const Center(child: CircularProgressIndicator());
                
                } else if(state is ChatLoadedState){
                  List<MessageEntity> messages = state.messages;

                  return ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: messages.length,
                    itemBuilder: (context, index){
                      final content = messages[index];
                      final isSentMessage = content.senderId == userId;
                      if(isSentMessage){
                        return _buildSentMessage(context, content.message);
                      } else {
                       return _buildReceiveMessage(context, content.message);
                      }
                    },
                  );
                } else if (state is ChatErrorState){
                  return Center(child: Text(state.errorMessage));
                } else{
                  return const Center(child: Text("Failed to load messages"));
                }

            } )),
          _buildMessageInput(),
        ],
      ),
    );
  }

Widget _buildReceiveMessage(BuildContext context, String message){
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(right: 30, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message, 
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    ),

  );
}

Widget _buildSentMessage(BuildContext context, String message){
  return Align(
    alignment: Alignment.centerRight,
    child: Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(left: 30, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message, 
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),

  );
}


Widget _buildMessageInput(){
  return Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            GestureDetector(
              onTap: (){},
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child:TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
            )),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: _sendMessage,
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),

          ],
        )
      );
    
}
}


