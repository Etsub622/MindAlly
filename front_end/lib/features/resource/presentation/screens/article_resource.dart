import 'package:flutter/material.dart';
import 'package:front_end/features/resource/presentation/screens/add_article.dart';

class ArticleResource extends StatefulWidget {
  const ArticleResource({super.key});

  @override
  State<ArticleResource> createState() => _ArticleResourceState();
}

class _ArticleResourceState extends State<ArticleResource> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resource Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Welcome to article Resources :)'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddArticle()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
