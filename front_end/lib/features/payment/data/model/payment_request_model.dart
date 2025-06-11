import 'package:front_end/features/payment/domain/entity/payment_request_entity.dart';

class PaymentRequestModel extends PaymentRequestEntity {

  const PaymentRequestModel({
    required super.therapistEmail,
    required super.patientEmail,
    required super.sessionHour,
    required super.pricePerHr,
  });

  Map<String, dynamic> toJson() => {
        'therapistEmail': therapistEmail,
        'patientEmail': patientEmail,
        'sessionDuration': sessionHour,
        'pricePerHr': pricePerHr,
      };
}
