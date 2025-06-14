import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/authentication/domain/repositories/auth_repo.dart';

class SendOtpUseCase extends Usecase<String, sendOtpParams> {
  final AuthRepository authRepository;
  SendOtpUseCase({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(sendOtpParams params) async {
    return await authRepository.sendOtp(params.email);
  }
}

class sendOtpParams {
  final String email;
  sendOtpParams(this.email);
}

class verifyOtpUsecase extends Usecase<String, verifyOtpParams> {
  final AuthRepository authRepository;
  verifyOtpUsecase({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(verifyOtpParams params) async {
    return await authRepository.verifyOtp(
      params.otp,
      params.email,
      params.verificationType,
    );
  }
}

class verifyOtpParams {
  final String otp;
  final String email;
  final String verificationType;
  verifyOtpParams(this.otp, this.email, this.verificationType);
}
