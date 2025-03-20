

import 'package:equatable/equatable.dart';

class PatientEntity extends Equatable {
   final String id;
  final String name;
  final String email;
  final bool hasPassword;
  final String role;
  final String? profilePicture;
  final String collage;

  const PatientEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.hasPassword,
    required this.role,
    this.profilePicture,
    required this.collage,
  });

  @override
  List<Object?> get props => [id,name, email, collage];

}