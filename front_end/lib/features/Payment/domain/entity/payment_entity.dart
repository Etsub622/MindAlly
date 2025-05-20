import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String therapistName;
  final double fee;
  final String txRef;
  final String paymentStatus;
  final String phoneNumber;
  const PaymentEntity({
    required this.id,
    required this.therapistName,
    required this.fee,
    required this.txRef,
    required this.paymentStatus,
    required this.phoneNumber
  });
  @override
  List<Object> get props {
    return [
      id,
      therapistName,
      fee,
      txRef,
      paymentStatus,
      phoneNumber
    ];
  }
}
