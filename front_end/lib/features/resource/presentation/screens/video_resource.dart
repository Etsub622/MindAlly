import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/core/routes/app_path.dart';
import 'package:front_end/features/resource/domain/entity/video_entity.dart';
import 'package:front_end/features/resource/presentation/bloc/video_bloc/bloc/video_bloc.dart';
import 'package:front_end/features/resource/presentation/screens/add_video.dart';
import 'package:front_end/features/resource/presentation/screens/update_video.dart';
import 'package:front_end/features/resource/presentation/widget/video_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoResource extends StatefulWidget {
  final String? currentUserRole;
  const VideoResource({super.key, this.currentUserRole});

  @override
  State<VideoResource> createState() => _VideoResourceState();
}

class _VideoResourceState extends State<VideoResource> {
  String? currentUserId;
  String? currentUserRole;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<VideoBloc>().add(GetVideoEvent());
    _loadCurrentUserId();
  }

  List<String> videoCategories = const [
    'Depression',
    'Anxiety',
    'OCD',
    'General',
    'Trauma',
    'SelfLove'
  ];
  String? selectedCategory;

  void _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      setState(() {
        print('userMap: $userMap');

        currentUserId = userMap["_id"] ?? '';
        currentUserRole = userMap["Role"];
        print('userId:$currentUserId');
        print('role : $currentUserRole');
      });
    } else {
      print('No user profile found in shared preferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E1E1),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for videos...',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(239, 130, 5, 220),
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(239, 130, 5, 220),
                      ),
                      onSubmitted: (query) {
                        if (query.isNotEmpty) {
                          context
                              .read<VideoBloc>()
                              .add(SearchVideoEvent(query));
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.search, size: 24, color: Colors.grey),
                    onPressed: () {
                      final query = _searchController.text;
                      if (query.isNotEmpty) {
                        context.read<VideoBloc>().add(SearchVideoEvent(query));
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh,
                    color: Color.fromARGB(239, 130, 5, 220)),
                onPressed: () {
                  FocusScope.of(context).unfocus(); // dismiss keyboard
                  _searchController.clear();
                  context.read<VideoBloc>().add(GetVideoEvent());
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list,
                    color: Color.fromARGB(239, 130, 5, 220)),
                onOpened: () {
                  FocusScope.of(context).unfocus(); // dismiss keyboard
                },
                onSelected: (String newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                  context
                      .read<VideoBloc>()
                      .add(SearchVideoByCategoryEvent(newValue));
                },
                itemBuilder: (BuildContext context) {
                  return videoCategories.map((String category) {
                    return PopupMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Color.fromARGB(239, 130, 5, 220),
                        ),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: BlocConsumer<VideoBloc, VideoState>(
            listener: (context, state) {
              if (state is VideoDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Video deleted successfully!'),
                  backgroundColor: Colors.green,
                ));
                context.read<VideoBloc>().add(GetVideoEvent());
              } else if (state is VideoError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
            },
            builder: (context, state) {
              if (state is VideoLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is SearchFailed) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else if (state is VideoLoaded) {
                final videos = state.videos;
                if (videos.isEmpty) {
                  return Center(child: Text('No Videos available.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return VideoCard(
                      onUpdate: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateVideo(
                              id: video.id,
                              title: video.title,
                              link: video.link,
                              image: video.image,
                              ownerId: video.ownerId,
                              profilePicture: video.profilePicture,
                              name: video.name,
                              categories: video.categories,
                              onUpdate: (updatedVideoMap) {
                                final updatedVideo = VideoEntity(
                                  type: video.type,
                                  id: video.id,
                                  title: updatedVideoMap['title'] as String,
                                  link: updatedVideoMap['link'] as String,
                                  image: updatedVideoMap['imageUrl'] as String,
                                  profilePicture: video.profilePicture,
                                  name: video.name,
                                  categories: video.categories,
                                  ownerId: video.ownerId,
                                );
                                context.read<VideoBloc>().add(
                                    UpdateVideoEvent(updatedVideo, video.id));
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
                      video: video,
                      currentUserId: currentUserId ?? '',
                      ownerId: video.ownerId,
                      role: currentUserRole ?? '',
                    );
                  },
                );
              } else {
                return Center(child: Text('Something went wrong!'));
              }
            },
          ),
          floatingActionButton:
              (currentUserId != null && currentUserRole == 'therapist')
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddVideo()),
                        );
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Colors.purple,
                    )
                  : null),
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
