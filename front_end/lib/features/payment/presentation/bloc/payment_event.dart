
part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class InitiatePaymentEvent extends PaymentEvent {
  final String therapistEmail;
  final String patientEmail;
  final double sessionHour;
  final double pricePerHr;

  const InitiatePaymentEvent({
    required this.therapistEmail,
    required this.patientEmail,
    required this.sessionHour,
    required this.pricePerHr,
  });

  @override
  List<Object> get props => [therapistEmail, patientEmail, sessionHour, pricePerHr];
}