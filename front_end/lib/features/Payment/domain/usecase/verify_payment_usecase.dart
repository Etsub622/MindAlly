import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/Payment/domain/repository/payment_repository.dart';

class VerifyPaymentUsecase extends Usecase<String,VerifyParams>{
  final PaymentRepository repository;

  VerifyPaymentUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyParams params) async {
    return await repository.verifyPayment(params.txRef);
  }
}

class VerifyParams {
  final String txRef;

  VerifyParams(this.txRef);
}