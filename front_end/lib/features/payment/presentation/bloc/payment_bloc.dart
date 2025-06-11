import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/payment/data/model/payment_request_model.dart';
import 'package:front_end/features/payment/domain/usecase/initiate_payment_use_case.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePaymentUseCase initiatePaymentUseCase;

  PaymentBloc(this.initiatePaymentUseCase) : super(PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
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
}
