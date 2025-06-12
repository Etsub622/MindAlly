import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/payment/data/model/payment_request_model.dart';
import 'package:front_end/features/payment/domain/usecase/initiate_payment_use_case.dart';
import 'package:front_end/features/payment/domain/usecase/withdraw_payment_use_case.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePaymentUseCase initiatePaymentUseCase;
  final WithdrawPaymentUseCase withdrawPaymentUseCase;

  PaymentBloc(this.initiatePaymentUseCase, this.withdrawPaymentUseCase) : super(PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<WithdrawPaymentEvent>(_onWithdrawPayment);
  }

  Future<void> _onInitiatePayment(
      InitiatePaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
      final payment = PaymentRequestModel(
        therapistEmail: event.therapistEmail,
        patientEmail: event.patientEmail,
        sessionHour: event.sessionHour,
        pricePerHr: event.pricePerHr,
      );
      final checkoutUrl = await initiatePaymentUseCase(payment);
      checkoutUrl.fold(
        (failure) => emit(PaymentFailure(error: failure.message)),
        (checkoutUrl) => emit(PaymentSuccess(checkoutUrl: checkoutUrl)),
      );
  }

  Future<void> _onWithdrawPayment(
      WithdrawPaymentEvent event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());

      final checkoutUrl = await withdrawPaymentUseCase(PaymentWithDrawPharam(email: event.email, amount: event.amount));
      checkoutUrl.fold(
        (failure) => emit(PaymentFailure(error: failure.message)),
        (checkoutUrl) => emit(PaymentSuccess(checkoutUrl: checkoutUrl)),
      );
  }
}
