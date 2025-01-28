import 'package:equatable/equatable.dart';
import 'package:front_end/features/profile/domain/entities/user_entity.dart';

class TherapistEntity extends Equatable{
  final UserEntity userEntity;
  final String certificate;
  final String bio;
  final int fee;
  final double rating;
  final bool verified;

  const TherapistEntity({
    required this.userEntity,
    required this.certificate,
    required this.bio,
    required this.fee,
    required this.rating,
    required this.verified

  });

  @override
  List<Object?> get props => [userEntity, certificate];

}