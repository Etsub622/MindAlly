import 'package:flutter/material.dart';
import 'package:front_end/features/resource/presentation/screens/add_book.dart';

class BookResource extends StatefulWidget {
  const BookResource({super.key});

  @override
  State<BookResource> createState() => _BookResourceState();
}

class _BookResourceState extends State<BookResource> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resource Room'),
      ),
      body: Column(
        children: [
          Text('Welcome to book Resources :)'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBook()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
