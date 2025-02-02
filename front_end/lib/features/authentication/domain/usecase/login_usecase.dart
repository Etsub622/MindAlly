import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/authentication/data/models/student_data_model.dart';
import 'package:front_end/features/authentication/domain/entities/login_entity.dart';
import 'package:front_end/features/authentication/domain/repositories/auth_repo.dart';

class LoginUsecase implements Usecase<StudentResponseModel, LogInParams>{
  final AuthRepository authRepository;
  LoginUsecase({required this.authRepository});

  @override
  Future<Either<Failure, StudentResponseModel>> call(LogInParams params) async {
    return await authRepository.login(params.loginEntity);
  }
}

class LogInParams{
  final LoginEntity loginEntity;
  LogInParams(this.loginEntity);
}