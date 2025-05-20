import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/Payment/domain/entity/payment_entity.dart';
import 'package:front_end/features/Payment/domain/repository/payment_repository.dart';

class InitiatePaymentUsecase implements Usecase<String,InitiateParams>{
  final PaymentRepository repository;

  InitiatePaymentUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(InitiateParams params) async{
   return await repository.initiatePayment(params.paymentEntity);
  }
}

class InitiateParams {
  final PaymentEntity paymentEntity;

  InitiateParams(this.paymentEntity);
}