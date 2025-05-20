import 'package:front_end/features/Payment/domain/entity/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.fee,
    required super.paymentStatus,
    required super.therapistName,
    required super.txRef,
    required super.phoneNumber
  });
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      fee: json['fee'],
      paymentStatus: json['paymentStatus'],
      therapistName: json['therapistName'],
      txRef: json['txRef'],
      phoneNumber: json['phoneNumber']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'fee': super.fee,
      'paymentStatus': super.paymentStatus,
      'therapistName': super.therapistName,
      'txRef': super.txRef,
      'phoneNumber':super.phoneNumber,
    };
  }
}
