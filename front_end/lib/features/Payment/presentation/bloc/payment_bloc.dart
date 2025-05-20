import 'package:bloc/bloc.dart';
import 'package:front_end/features/Payment/domain/entity/payment_entity.dart';
import 'package:front_end/features/Payment/domain/usecase/initiate_payment_usecase.dart';
import 'package:front_end/features/Payment/domain/usecase/verify_payment_usecase.dart';
import 'package:meta/meta.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePaymentUsecase initiatePaymentUsecase;
  final VerifyPaymentUsecase verifyPaymentUsecase;

  PaymentBloc({
    required this.initiatePaymentUsecase,
    required this.verifyPaymentUsecase,

  }) : super(PaymentInitial()) {
 on<InitiatePaymentEvent>((event, emit) async {
      emit(PaymentLoading());

      final result =
          await initiatePaymentUsecase(InitiateParams(event.paymentEntity));

      result.fold(
        (failure) => emit(PaymentError(failure.message)),
        (checkoutUrl) => emit(PaymentInitiated(checkoutUrl)),
      );
    });

    on<VerifyPaymentEvent>((event, emit) async {
      emit(PaymentLoading());

      final result = await verifyPaymentUsecase(VerifyParams(event.txRef));

      result.fold(
        (failure) => emit(PaymentError(failure.message)),
        (message) => emit(PaymentVerified(message)),
      );
    });
  }
}
