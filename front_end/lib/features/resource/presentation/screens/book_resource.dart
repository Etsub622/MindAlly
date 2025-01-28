import 'package:flutter/material.dart';

class BookResource extends StatefulWidget {
  const BookResource({super.key});

  @override
  State<BookResource> createState() => _BookResourceState();
}

class _BookResourceState extends State<BookResource> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:Text('Resource Room'),),
      body: Column(
        children: [
          Text('Welcome to book Resources :)'),
          
        ],
      ),
    );
  }
}
