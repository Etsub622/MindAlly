import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String content;
  final String logo;
  final String link;
  const ArticleCard(
      {super.key,
      required this.content,
      required this.link,
      required this.logo,
      required this.title});

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
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 17),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              content,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(logo),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(title),
              ],
            )
          ],
        ),
      ),
    );
  }
}
