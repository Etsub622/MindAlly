import 'package:flutter/material.dart';

class AnswerCard extends StatefulWidget {
  final String answer;
  final String therapistName;
  final String therapistProfile;
  final void Function() onPressed;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const AnswerCard({
    required this.answer,
    required this.therapistName,
    required this.therapistProfile,
    required this.onPressed,
    required this.onDelete,
    required this.onUpdate,
    super.key,
  });

  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: _isExpanded ? 8 : 0,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.therapistProfile),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.therapistName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Spacer(),
                  // PopupMenuButton<String>(
                  //   icon: Icon(Icons.more_vert),
                  //   onSelected: (value) {
                  //     if (value == 'update') {
                  //       widget.onUpdate();
                  //     } else if (value == 'delete') {
                  //       widget.onDelete();
                  //     }
                  //   },
                  //   itemBuilder: (context) => [
                  //     const PopupMenuItem(
                  //       value: 'update',
                  //       child: Text('Update'),
                  //     ),
                  //     const PopupMenuItem(
                  //       value: 'delete',
                  //       child: Text('Delete'),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                widget.answer,
                maxLines: _isExpanded ? null : 3,
                overflow: _isExpanded ? null : TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Text(
                  _isExpanded ? 'Read less' : 'Read more',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
