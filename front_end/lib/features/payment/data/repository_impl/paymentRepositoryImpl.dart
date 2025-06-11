
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/payment/data/datasource/remote_datasource/paymentRemoteDataSource.dart';
import 'package:front_end/features/payment/data/model/payment_request_model.dart';
import 'package:front_end/features/payment/domain/repository/paymentRepository.dart';

class PaymentRepositoryImpl extends PaymentRepository  {
  final PaymentRemoteDataSource  paymentRemoteDataSource;
  final NetworkInfo networkInfo;

  PaymentRepositoryImpl({
    required this.paymentRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> initiatePayment(PaymentRequestModel payment) async {
    // if (await networkInfo.isConnected) {
      try {
        final result = await paymentRemoteDataSource.initiatePayment(payment);
        return Right(result);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    // } else {
    //   return Left(ServerFailure(message: "No Internet Connection"));
    // }

  }
}


