import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/authentication/domain/entities/student_signup_entity.dart';
import 'package:front_end/features/authentication/domain/repositories/auth_repo.dart';

class StudentSignupUsecase implements Usecase<String, SignUpParams> {
  final AuthRepository authRepository;
  StudentSignupUsecase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(SignUpParams params) async {
    return await authRepository.studentSignUp(params.signupEntity);
  }
}

class SignUpParams {
  final StudentSignupEntity signupEntity;
  SignUpParams(this.signupEntity);
}
