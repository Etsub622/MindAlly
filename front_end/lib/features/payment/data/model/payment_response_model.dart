class PaymentResponseModel {
  final String? checkoutUrl;
  final String? error;

  PaymentResponseModel({this.checkoutUrl, this.error});

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      checkoutUrl: json['checkout_url'],
      error: json['error'],
    );
  }
}