import 'package:flutter/material.dart';
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';
import 'package:go_router/go_router.dart';

class TherapistProfileWidget extends StatefulWidget {
  final UpdateTherapistEntity therapist;
  final BuildContext upperContext;

  const TherapistProfileWidget({
    super.key,
    required this.upperContext,
    required this.therapist,
  });

  @override
  State<TherapistProfileWidget> createState() => _TherapistProfileWidgetState();
}

class _TherapistProfileWidgetState extends State<TherapistProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(widget.upperContext).pushNamed(
            'therapistDetails',
            extra: widget.therapist, // Pass the therapist object
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          color: const Color.fromARGB(255, 248, 240, 249),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Hero(
                    tag: 'therapist_${widget.therapist.id}',
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: const Color.fromARGB(255, 49, 37, 54),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          widget.therapist.profilePicture ??
                              "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
                        ),
                        backgroundColor: const Color.fromARGB(255, 139, 125, 145)
                      ),
                    ),
                  ),
                  title: Text(
                    widget.therapist.name ?? "Unknown",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900],
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        widget.therapist.modality ?? "Not specified",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                      Text(
                        "${widget.therapist.experienceYears ?? 0} Years of Experience",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       widget.therapist.fee != null
                //           ? "\$${widget.therapist.fee}"
                //           : "N/A",
                //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.purple[700],
                //           ),
                //     ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     GoRouter.of(widget.upperContext).pushNamed(
                    //       'chatDetails',
                    //       queryParameters: {
                    //         "chatId": widget.therapist.chatId,
                    //         "id": widget.therapist.id,
                    //         "name": widget.therapist.name,
                    //         "email": widget.therapist.email,
                    //         "hasPassword": "false",
                    //         "role": "therapist",
                    //       },
                    //     );
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.purple[700],
                    //     foregroundColor: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10)),
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 20, vertical: 12),
                    //   ),
                    //   child: const Text(
                    //     "Chat",
                    //     style: TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                  // ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}