
import 'package:flutter/material.dart';
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';
import 'package:go_router/go_router.dart';

class TherapistDetailScreen extends StatelessWidget {
  final UpdateTherapistEntity therapist;

  const TherapistDetailScreen({super.key, required this.therapist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'therapist_${therapist.id}',
                child: Image.network(
                  therapist.profilePicture ??
                      "https://cache.lovethispic.com/uploaded_images/thumbs/213123-Kiss-The-Sun.jpg",
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[200]),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.purple[700],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    therapist.name ?? "Unknown",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    therapist.modality ?? "Not specified",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.work, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        "${therapist.experienceYears ?? 0} Years of Experience",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        therapist.fee != null ? "\$${therapist.fee}/hr" : "N/A",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[700],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "About",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    therapist.bio ??
                        "No bio available. Contact the therapist for more details.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[800],
                        ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).pushNamed(
                          'chatDetails',
                          queryParameters: {
                            "chatId": therapist.chatId,
                            "id": therapist.id,
                            "name": therapist.name,
                            "email": therapist.email,
                            "hasPassword": "false",
                            "role": "therapist",
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Start Chat",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}