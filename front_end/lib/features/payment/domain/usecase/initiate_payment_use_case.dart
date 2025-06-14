

import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/payment/data/model/payment_request_model.dart';
import 'package:front_end/features/payment/domain/repository/paymentRepository.dart';

class InitiatePaymentUseCase extends Usecase<String, PaymentRequestModel> {
  final PaymentRepository repository;

  InitiatePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(PaymentRequestModel payment) async {
    return await repository.initiatePayment(payment);
  }
}