import 'dart:convert';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/payment/data/model/payment_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:front_end/core/config/config_key.dart';

abstract class PaymentRemoteDataSource {
  Future<String> initiatePayment(PaymentRequestModel request);
  Future<String> withdrawPayment(String email, double amount);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final http.Client client;
  PaymentRemoteDataSourceImpl(this.client);


  final String baseUrl = '${ConfigKey.baseUrl}/Payment';

  @override
  Future<String> initiatePayment(PaymentRequestModel request) async {
    try {
      var url = Uri.parse('$baseUrl/pay');
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedBody = jsonDecode(response.body);
        return decodedBody["data"]["checkout_url"];
      } else {
        throw ServerException(
            message: 'Failed to initiate payment:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> withdrawPayment(String email, double amount) async {
    try {
      var url = Uri.parse('$baseUrl/withdraw');
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "therapistEmail": email,
          "amount": amount,
        }),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedBody = jsonDecode(response.body);
        return decodedBody["data"]["checkout_url"];
      } else {
        final Map<String, dynamic> decodedError = jsonDecode(response.body);
        throw ServerException(
            message: decodedError["error"]?? 'Failed to withdraw payment');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}