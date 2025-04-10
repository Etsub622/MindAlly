import 'dart:convert';

import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/util/get_token.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';
import 'package:http/http.dart' as http;

abstract class HomeRemoteDataSource {
  Future<List<UpdateTherapistModel>> getMatchedTherapist(
      {required String patientId});
}

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  HomeRemoteDataSourceImpl();
  final baseUrl = "${ConfigKey.baseUrl}/therapists";

  @override
  Future<List<UpdateTherapistModel>> getMatchedTherapist(
      {required String patientId}) async {
    try {
      final String token = await getToken();
      print(token);
      final response = await http.get(
        Uri.parse('$baseUrl/top/$patientId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      print(token);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = response.body;
        final resData = json.decode(jsonResponse);
        final topTherapist = resData['top_therapists'];
        final List<UpdateTherapistModel> therapistList = topTherapist
            .map<UpdateTherapistModel>(
                (json) => UpdateTherapistModel.fromJson(json))
            .toList();
        return therapistList;
      } else {
        throw ServerException(message: 'Failed to load data');
      }
    } catch 
    (e) {
      throw ServerException(message: 'Failed to load data');
    }
  }
}
