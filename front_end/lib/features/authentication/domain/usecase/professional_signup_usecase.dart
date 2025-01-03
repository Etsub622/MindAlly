import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/authentication/domain/entities/professional_signup_entity.dart';
import 'package:front_end/features/authentication/domain/repositories/auth_repo.dart';


class ProfessionalSignupUsecase implements Usecase<String, ProfessionalSignUpParams> {
  final AuthRepository authRepository;
  ProfessionalSignupUsecase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(ProfessionalSignUpParams params) async {
    return await authRepository.professionalSignup(params.signupEntity);
  }
}

class ProfessionalSignUpParams {
  final ProfessionalSignupEntity signupEntity;
  ProfessionalSignUpParams(this.signupEntity);
}