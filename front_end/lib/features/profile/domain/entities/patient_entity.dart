

import 'package:equatable/equatable.dart';
import 'package:front_end/features/profile/domain/entities/user_entity.dart';

class PatientEntity extends Equatable {
  final UserEntity userEntity;
  final String collage;

  const PatientEntity({
    required this.userEntity,
    required this.collage,
  });

  @override
  List<Object?> get props => [userEntity, collage];

}