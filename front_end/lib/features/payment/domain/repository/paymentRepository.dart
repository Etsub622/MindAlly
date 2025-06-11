
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/payment/data/model/payment_request_model.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> initiatePayment(PaymentRequestModel payment);
}