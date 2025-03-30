import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/Home/domain/repostitory/home_respository.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';

class GetMatchedTherpaistsUseCase extends Usecase<List<UpdateTherapistModel>, String> {
  final HomeRespository homeRepository;
  GetMatchedTherpaistsUseCase({required this.homeRepository});

  @override
  Future<Either<Failure, List<UpdateTherapistModel>>> call(String params) {
    return homeRepository.getMatchedTherapist(patientId: params);
  }
}