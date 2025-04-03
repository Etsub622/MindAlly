import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  final String name;
  final String title;
  final String content;
  final List<String> category;
  final String profileImage;
  final void Function() onPressed;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const QuestionCard({
    required this.name,
    required this.title,
    required this.content,
    required this.category,
    required this.profileImage,
    required this.onPressed,
    required this.onDelete,
    required this.onUpdate,
    super.key,
  });

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.profileImage),
                  radius: 22,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                  onSelected: (value) {
                    if (value == 'update') {
                      widget.onUpdate();
                    } else if (value == 'delete') {
                      widget.onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'update', child: Text('Edit')),
                    PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete',
                            style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            AnimatedCrossFade(
              duration: Duration(milliseconds: 250),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                widget.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
              secondChild: Text(
                widget.content,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                children: [
                  Text(
                    _isExpanded ? 'Read less' : 'Read more',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Color.fromARGB(239, 130, 5, 220),
                    size: 18,
                  ),
                ],
              ),
            ),
            SizedBox(height: 7),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: widget.category.map((cat) {
                return Chip(
                  backgroundColor: Colors.blue[50],
                  label: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(239, 130, 5, 220),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: widget.onPressed,
                icon: Icon(Icons.message,
                    color: Color.fromARGB(239, 130, 5, 220), size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
