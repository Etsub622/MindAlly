import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_end/features/resource/domain/entity/article_entity.dart';

class ArticleCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;
  const ArticleCard(
      {super.key, 
      required this.article,
      required this.onDelete,
      required this.onUpdate,
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Text(
              article.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 17),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              article.content,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(article.logo),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(article.title),
              ],
            ),
            SizedBox(
              width: 15,
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
      ),
    );
  }
}
