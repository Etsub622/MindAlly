import 'package:flutter/material.dart';
import 'package:front_end/core/util/chat_bot_service.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
  }

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ChatService _chatService = ChatService();

  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": message});
    });

    _controller.clear();

    String response = await _chatService.getChatResponse(message);

    setState(() {
      _messages.add({"role": "bot", "content": response});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dr. MindAlly"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 6,
                      horizontal: MediaQuery.of(context).size.width / 5,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "asset/image/chatbot.png",
                            height: 100,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Hello! I’m here to support users with mental health concerns, 24/7.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Align(
                        alignment: message["role"] == "user"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: message["role"] == "user"
                                ? Colors.teal
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SelectableText(
                            message["content"]!,
                            style: TextStyle(
                              color: message["role"] == "user"
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            // Optional: Customize selection toolbar
                            toolbarOptions: const ToolbarOptions(
                              copy: true,
                              selectAll: true,
                              cut: false,
                              paste: false,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "How can I assist you today?",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

