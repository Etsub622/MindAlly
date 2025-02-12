import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:front_end/features/resource/domain/entity/video_entity.dart';

class VideoCard extends StatelessWidget {
final VideoEntity video;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;


  const VideoCard(
      {super.key,
      required this.video,
      required this.onDelete,
      required this.onUpdate
      
      });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Image.network(
            video.image,
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
                backgroundImage: NetworkImage(video.profilePicture),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 17),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(video.name),
                ],
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
        ],
      ),
    );
  }
}
