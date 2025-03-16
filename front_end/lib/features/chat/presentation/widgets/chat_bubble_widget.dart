import 'package:flutter/material.dart';

class ChatBubbleWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final String? dataType;
  final String? dataUrl;

  const ChatBubbleWidget(
      {super.key,
      required this.message,
      required this.isMe,
      this.dataType,
      this.dataUrl});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: isMe ? Colors.blueAccent : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: isMe
                      ? const Radius.circular(15)
                      : const Radius.circular(0),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(15),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
            // dataType == null
            //     ? const SizedBox.shrink()
            //     : SizedBox(
            //         height: MediaQuery.of(context).size.height * 0.2,
            //         width: MediaQuery.of(context).size.width * 0.5,
            //         child: dataType == 'image'
            //             ? Image.network(dataUrl!)
            //             : dataType == 'file'
            //                 ? ElevatedButton(
            //                     onPressed: () {},
            //                     child: const Text('Download File'),
            //                   )
            //                 : const SizedBox(),
            //       )
          ],
        ));
  }
}
