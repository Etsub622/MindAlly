import 'package:equatable/equatable.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';

class TherapistEntity extends Equatable{
  final String id;
  final String name;
  final String email;
  final bool hasPassword;
  final String role;
  final String? profilePicture;
  final String certificate;
  final String bio;
  final int fee;
  final double rating;
  final bool verified;
  final PayoutModel? payout;

  const TherapistEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.hasPassword,
    required this.role,
    this.profilePicture,
    required this.certificate,
    required this.bio,
    required this.fee,
    required this.rating,
    required this.verified,
    this.payout
  });

  @override
  List<Object?> get props => [id,name,email, certificate];

}
