import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/resource/domain/entity/video_entity.dart';
import 'package:front_end/features/resource/presentation/bloc/video_bloc/bloc/video_bloc.dart';
import 'package:front_end/features/resource/presentation/screens/add_video.dart';
import 'package:front_end/features/resource/presentation/screens/update_video.dart';
import 'package:front_end/features/resource/presentation/widget/video_card.dart';

class VideoResource extends StatefulWidget {
  const VideoResource({super.key});

  @override
  State<VideoResource> createState() => _VideoResourceState();
}

class _VideoResourceState extends State<VideoResource> {
  @override
  void initState() {
    super.initState();

    context.read<VideoBloc>().add(GetVideoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              icon:const Icon(
                Icons.refresh,
                color: Color.fromARGB(239, 130, 5, 220),
                size: 25,
              ),
              onPressed: () {
                context.read<VideoBloc>().add(GetVideoEvent());
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<VideoBloc, VideoState>(
        builder: (context, state) {
          if (state is VideoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is VideoError) {
            return Center(child: Text(state.message));
          } else if (state is VideoLoaded) {
            final videos = state.videos;
            if (videos.isEmpty) {
              return Center(child: Text('No Videos available.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return VideoCard(
                    onUpdate: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateVideo(
                            title: video.title,
                            link: video.link,
                            image: video.image,
                            profilePicture: video.profilePicture,
                            name: video.name,
                            onUpdate: (updatedVideoMap) {
                              final updatedBook = VideoEntity(
                                type: video.type,
                                id: video.id,
                                title: updatedVideoMap['title'] as String,
                                link: updatedVideoMap['link'] as String,
                                image: updatedVideoMap['imageUrl'] as String,
                                profilePicture: video.profilePicture,
                                name: video.name,
                                categories: video.categories,
                              );
                              context
                                  .read<VideoBloc>()
                                  .add(UpdateVideoEvent(updatedBook, video.id));
                            },
                          ),
                        ),
                      );

                      if (result == true) {
                        context
                            .read<VideoBloc>()
                            .add(GetSingleVideoEvent(video.id));
                      }
                    },
                    onDelete: () {
                      _showDeleteDialog(context, video.id);
                    },
                    video: video);
              },
            );
          } else {
            return Center(child: Text('Something went wrong!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddVideo()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<VideoBloc>().add(DeleteVideoEvent(id));
                Navigator.of(context).pop();
                context.read<VideoBloc>().add(GetVideoEvent());
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
