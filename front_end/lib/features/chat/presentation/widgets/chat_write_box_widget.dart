import 'package:flutter/material.dart';

class ChatWriteBoxWidget extends StatefulWidget {
  final Function(String) onSend;
  const ChatWriteBoxWidget({super.key, required this.onSend});

  @override
  _ChatWriteBoxWidgetState createState() => _ChatWriteBoxWidgetState();
}

class _ChatWriteBoxWidgetState extends State<ChatWriteBoxWidget> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onSend(_controller.text);
              _controller.clear();
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
