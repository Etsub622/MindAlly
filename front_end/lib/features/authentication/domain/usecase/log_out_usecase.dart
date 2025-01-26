import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/authentication/domain/repositories/log_out_repo.dart';

class LogOutUsecase extends Usecase<void, NoParams> {
  final LogOutRepo logOutRepo;
  LogOutUsecase(this.logOutRepo);


  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await logOutRepo.logOut();
  }
}
