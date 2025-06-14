import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/Home/domain/repostitory/home_respository.dart';
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';

class GetAllTherapistsUsecase {
  final HomeRespository homeRepository;

  GetAllTherapistsUsecase({required this.homeRepository});

  Future<Either<Failure, List<UpdateTherapistEntity>>> call() async {
    return await homeRepository.getAllTherapists();
  }
}