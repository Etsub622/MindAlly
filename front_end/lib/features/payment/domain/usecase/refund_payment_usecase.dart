
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/payment/domain/repository/paymentRepository.dart';

class RefundPaymentUseCase extends Usecase<String, PaymentRefundPharam> {
  final PaymentRepository repository;

  RefundPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(PaymentRefundPharam pharam) async {
    return await repository.refundPayment(pharam.therapistEmail, pharam.patientEmail, pharam.sessionId);
  }
}

class PaymentRefundPharam {
  String therapistEmail;
  String patientEmail;
  String sessionId;

  PaymentRefundPharam({
    required this.therapistEmail,
    required this.patientEmail,
    required this.sessionId,
  });
}