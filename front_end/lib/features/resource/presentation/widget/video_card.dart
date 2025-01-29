import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VideoCard extends StatelessWidget {
  final String image;
  final String title;
  final String link;
  final String profilePicture;
  final String name;

  const VideoCard(
      {super.key,
      required this.image,
      required this.link,
      required this.name,
      required this.profilePicture,
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
            height: 10,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(profilePicture),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
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
                  Text(name),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
