part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {
  const PaymentEvent();
}

class InitiatePaymentEvent extends PaymentEvent {
  final PaymentEntity paymentEntity;
  const InitiatePaymentEvent(this.paymentEntity);
}

class VerifyPaymentEvent extends PaymentEvent {
  final String txRef;
  const VerifyPaymentEvent(this.txRef);
}
