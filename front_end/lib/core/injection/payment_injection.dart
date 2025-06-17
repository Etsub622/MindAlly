
import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/features/payment/data/datasource/remote_datasource/paymentRemoteDataSource.dart';
import 'package:front_end/features/payment/data/repository_impl/paymentRepositoryImpl.dart';
import 'package:front_end/features/payment/domain/repository/paymentRepository.dart';
import 'package:front_end/features/payment/domain/usecase/initiate_payment_use_case.dart';
import 'package:front_end/features/payment/domain/usecase/refund_payment_usecase.dart';
import 'package:front_end/features/payment/domain/usecase/withdraw_payment_use_case.dart';
import 'package:front_end/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:http/http.dart' as http;

class PaymentInjection {
  void init() {
    print('PaymentInjection initialized');
    try {
      // Data Source
      sl.registerLazySingleton<PaymentRemoteDataSource>(
        () => PaymentRemoteDataSourceImpl(sl<http.Client>()),
      );

      // Repository
      sl.registerLazySingleton<PaymentRepository>(
        () => PaymentRepositoryImpl(
          paymentRemoteDataSource:sl(),
          networkInfo: sl()
        ),
      );

      // Use Cases
      sl.registerLazySingleton<InitiatePaymentUseCase>(
        () => InitiatePaymentUseCase(sl<PaymentRepository>()),
      );
      
      sl.registerLazySingleton<WithdrawPaymentUseCase>(
        () => WithdrawPaymentUseCase(sl<PaymentRepository>()),
      );

      sl.registerLazySingleton<RefundPaymentUseCase>(
        () => RefundPaymentUseCase(sl<PaymentRepository>()),
      );

      // Bloc
      sl.registerFactory<PaymentBloc>(
        () => PaymentBloc(
          sl<InitiatePaymentUseCase>(),
          sl<WithdrawPaymentUseCase>(),
          sl<RefundPaymentUseCase>()
        ),
      );

      print("Payment dependencies registered successfully");
    } catch (e) {
      print("Error registering Payment dependencies: $e");
      rethrow;
    }
  }
}
