import 'package:equatable/equatable.dart';

class PaymentRequestEntity extends Equatable {
  final String therapistEmail;
  final String patientEmail;
  final double sessionHour;
  final double pricePerHr;

  const PaymentRequestEntity({
    required this.therapistEmail,
    required this.patientEmail,
    required this.sessionHour,
    required this.pricePerHr,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [therapistEmail, patientEmail, sessionHour, pricePerHr];
}