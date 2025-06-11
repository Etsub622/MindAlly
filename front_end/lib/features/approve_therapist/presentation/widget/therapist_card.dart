import 'package:flutter/material.dart';
import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';
import 'package:front_end/features/approve_therapist/presentation/screen/therapist_verify_detail.dart';

class TherapistCard extends StatelessWidget {
  final TherapistVerifyEntity therapist;

  const TherapistCard({Key? key, required this.therapist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.grey), // Placeholder
        ),
        title: Text(
          therapist.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          therapist.specialization,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        trailing: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View Certificate',
              style: TextStyle(color: Colors.blue, fontSize: 12),
            ),
            SizedBox(width: 4),
            Icon(Icons.description, color: Colors.blue, size: 20),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TherapistDetailPage(therapist: therapist),
            ),
          );
        },
      ),
    );
  }
}
