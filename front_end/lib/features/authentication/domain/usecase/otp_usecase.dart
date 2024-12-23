import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/authentication/domain/repositories/auth_repo.dart';

class SendOtpUseCase extends Usecase<String,sendOtpParams>{
  final AuthRepository authRepository;
  SendOtpUseCase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(sendOtpParams params) async {
    return await authRepository.sendOtp(params.phoneNumber);
  }
}
class sendOtpParams{
  final String phoneNumber;
  sendOtpParams(this.phoneNumber);
}

class verifyOtpUsecase extends Usecase<String,verifyOtpParams>{
  final AuthRepository authRepository;
  verifyOtpUsecase(this.authRepository);

  @override
  Future<Either<Failure, String>> call(verifyOtpParams params) async {
    return await authRepository.verifyOtp(params.otp,params.phoneNumber);
  }
}
class verifyOtpParams{
  final String otp;
  final String phoneNumber;
  verifyOtpParams(this.otp,this.phoneNumber);
}