// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_end/features/resource/domain/entity/book_entity.dart';

class BookItem extends StatelessWidget {
  final BookEntity book;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const BookItem(
      {required this.book,
      required this.onDelete,
      required this.onUpdate,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: book.image.isNotEmpty
                  ? Image.network(
                      book.image,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey[200],
                      child:
                          Icon(Icons.book, size: 50, color: Colors.grey[600]),
                    ),
            ),
          ),
         Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert), 
                      onSelected: (value) {
                        if (value == 'update') {
                          onUpdate();
                        } else if (value == 'delete') {
                          onDelete();
                           
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'update',
                          child: Text('Update'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  book.author,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
