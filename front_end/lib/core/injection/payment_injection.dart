import 'package:front_end/core/injection/injections.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/Payment/data/datasources/payment_datasource.dart';
import 'package:front_end/features/Payment/data/repo_impl/payment_repo_impl.dart';
import 'package:front_end/features/Payment/domain/repository/payment_repository.dart';
import 'package:front_end/features/Payment/domain/usecase/initiate_payment_usecase.dart';
import 'package:front_end/features/Payment/domain/usecase/verify_payment_usecase.dart';
import 'package:front_end/features/Payment/presentation/bloc/payment_bloc.dart';
import 'package:http/http.dart' as http;

class PaymentInjection {
  void init() {
    try {
      // Data Source
      sl.registerLazySingleton<PaymentDatasource>(
        () => PaymentRemoteRepoImpl(sl<http.Client>()),
      );

      // Repository
      sl.registerLazySingleton<PaymentRepository>(() => PaymentRepoImpl(
            sl<NetworkInfo>(),
            sl<PaymentDatasource>(),
          ));

      // Use Cases
      sl.registerLazySingleton<VerifyPaymentUsecase>(
        () => VerifyPaymentUsecase(sl<PaymentRepository>()),
      );

      sl.registerLazySingleton<InitiatePaymentUsecase>(
        () => InitiatePaymentUsecase(sl<PaymentRepository>()),
      );

      // Bloc
      sl.registerFactory<PaymentBloc>(
        () => PaymentBloc(
          initiatePaymentUsecase: sl<InitiatePaymentUsecase>(),
          verifyPaymentUsecase: sl<VerifyPaymentUsecase>(),
        ),
      );
    } catch (e) {
      print("Error registering payment dependencies: $e");
      rethrow;
    }
  }
}
