import 'dart:convert';

import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/Payment/data/model/payment_model.dart';
import 'package:http/http.dart' as http;

abstract class PaymentDatasource {
  Future<String> initiatePayment(PaymentModel paymentModel);
  Future<String> verifyPayment(String txRef);
}

class PaymentRemoteRepoImpl implements PaymentDatasource {
  final http.Client client;
  PaymentRemoteRepoImpl(this.client);
  final baseUrl = '${ConfigKey.baseUrl}/Payment';

  @override
  Future<String> initiatePayment(PaymentModel paymentModel) async {
    try {
      var url = Uri.parse('$baseUrl/pay');
      print('url:$url');
      final newPayment = await client.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: paymentModel.toJson());
      print(newPayment.statusCode);
      print(newPayment.body);
      if (newPayment.statusCode == 200) {
        final responseData = jsonDecode(newPayment.body);
        return responseData['data']['checkout_url'] as String;
      } else {
        throw ServerException(
            message: 'Failed to initiate payment:${newPayment.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> verifyPayment(String txRef) async {
    try {
      var url = Uri.parse('$baseUrl/verifyPayment/$txRef');
      final verifyPayment = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('verifyPayment.statusCode: ${verifyPayment.statusCode}');
      print('verifyPayment.body: ${verifyPayment.body}');

      if (verifyPayment.statusCode == 200) {
        final decodedResponse = verifyPayment.body;
        print(decodedResponse);
        return decodedResponse;
      } else {
        throw ServerException(
            message: 'Failed to verify payment:${verifyPayment.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
