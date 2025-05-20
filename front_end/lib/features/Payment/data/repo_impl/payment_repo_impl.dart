import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/Payment/data/datasources/payment_datasource.dart';
import 'package:front_end/features/Payment/data/model/payment_model.dart';
import 'package:front_end/features/Payment/domain/entity/payment_entity.dart';
import 'package:front_end/features/Payment/domain/repository/payment_repository.dart';

class PaymentRepoImpl implements PaymentRepository {
  final PaymentDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  PaymentRepoImpl(this.networkInfo, this.remoteDatasource);

  @override
  Future<Either<Failure, String>> initiatePayment(PaymentEntity payment) async {
    if (await networkInfo.isConnected) {
      final newPayment = PaymentModel(
          id: payment.id,
          fee: payment.fee,
          paymentStatus: payment.paymentStatus,
          therapistName: payment.therapistName,
          txRef: payment.txRef,
          phoneNumber: payment.phoneNumber);
      final res = await remoteDatasource.initiatePayment(newPayment);
      print('res : $res');
      return Right(res);
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyPayment(String txRef) async {
    if (await networkInfo.isConnected) {
      final res = await remoteDatasource.verifyPayment(txRef);
      return Right(res);
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }
}
