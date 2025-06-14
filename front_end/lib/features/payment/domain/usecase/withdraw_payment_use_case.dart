

import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/payment/domain/repository/paymentRepository.dart';

class WithdrawPaymentUseCase extends Usecase<String, PaymentWithDrawPharam> {
  final PaymentRepository repository;

  WithdrawPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(PaymentWithDrawPharam pharam) async {
    return await repository.withdrawPayment(pharam.email, pharam.amount);
  }
}

class PaymentWithDrawPharam {
  String email;
  double amount;

  PaymentWithDrawPharam({
    required this.email,
    required this.amount,
  });
}