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
    return Material(
      elevation: _isExpanded ? 8 : 0,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
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
                  backgroundImage: NetworkImage(widget.profileImage),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Text(
                  widget.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'update') {
                      widget.onUpdate();
                    } else if (value == 'delete') {
                      widget.onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'update',
                      child: Text('Update'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.content,
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
            SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: widget.category.map((cat) {
                return Chip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12, // Reduce font size
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            InkWell(
              onTap: widget.onPressed,
              child: const Icon(Icons.message, color: Colors.blue, size: 28),
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
