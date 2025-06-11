part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String checkoutUrl;

  const PaymentSuccess({required this.checkoutUrl});

  @override
  List<Object> get props => [checkoutUrl];
}

class PaymentFailure extends PaymentState {
  final String error;

  const PaymentFailure({required this.error});

  @override
  List<Object> get props => [error];
}