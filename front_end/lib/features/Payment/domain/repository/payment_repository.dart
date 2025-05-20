import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/Payment/domain/entity/payment_entity.dart';

abstract class PaymentRepository {
  Future<Either<Failure, String>> initiatePayment(PaymentEntity payment);
  Future<Either<Failure,String>> verifyPayment(String txRef);
}