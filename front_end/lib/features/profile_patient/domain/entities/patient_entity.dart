

import 'package:equatable/equatable.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';

class PatientEntity extends Equatable {
   final String id;
  final String name;
  final String email;
  final bool hasPassword;
  final String role;
  final String? profilePicture;
  final String collage;
  final PayoutModel? payout;

  const PatientEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.hasPassword,
    required this.role,
    this.profilePicture,
    required this.collage,
    this.payout,
  });

  @override
  List<Object?> get props => [id,name, email, collage];

}