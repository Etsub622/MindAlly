part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentInitiated extends PaymentState {
  final String checkoutUrl;
  PaymentInitiated(this.checkoutUrl);
}

class PaymentVerified extends PaymentState {
  final String message;
  PaymentVerified(this.message);
}

class PaymentError extends PaymentState {
  final String message;
  PaymentError(this.message);
}
