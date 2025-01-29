import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BookCard extends StatelessWidget {
  final String image;
  final String title;
  final String author;

  const BookCard(
      {super.key,
      required this.image,
      required this.author,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Image.network(
            image,
            width: double.infinity,
            height: 400,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                author,
                style: TextStyle(
                    fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 17),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
