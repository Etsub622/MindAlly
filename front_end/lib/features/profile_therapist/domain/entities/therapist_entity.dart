import 'package:equatable/equatable.dart';

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
    required this.verified

  });

  @override
  List<Object?> get props => [id,name,email, certificate];

}