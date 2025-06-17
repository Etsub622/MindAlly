
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/payment/data/model/payment_request_model.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> initiatePayment(PaymentRequestModel payment);
  Future<Either<Failure, String>> withdrawPayment(String email, double amount,  String sessionId);
  Future<Either<Failure, String>> refundPayment(String therapistEmail, String patientEmail,  String sessionId);
}