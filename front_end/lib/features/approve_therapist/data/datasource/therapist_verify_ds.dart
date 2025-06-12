// lib/features/approve_therapist/data/datasource/therapist_verify_ds.dart
import 'dart:convert';
import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/approve_therapist/data/model/therapist_verify_model.dart';
import 'package:http/http.dart' as http;

abstract class TherapistVerifyRemoteDatasource {
  Future<List<TherapistVerifyModel>> getTherapists();
  Future<String> verifyTherapist(String id); // Removed reason
  Future<String> rejectTherapist(String id, String reason);
}

class TherapistVerifyRemoteDataSourceImpl
    implements TherapistVerifyRemoteDatasource {
  final http.Client client;
  TherapistVerifyRemoteDataSourceImpl(this.client);

  final baseUrl = '${ConfigKey.baseUrl}/therapists';

  @override
  Future<List<TherapistVerifyModel>> getTherapists() async {
    try {
      var url = Uri.parse('$baseUrl/unapproved');
      final response = await client.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => TherapistVerifyModel.fromJson(e)).toList();
      } else {
        throw ServerException(
            message: 'Failed to fetch therapists: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> verifyTherapist(String id) async {
    try {
      var url = Uri.parse('$baseUrl/$id/approve');
      final response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] as String;
      } else {
        throw ServerException(
            message: 'Failed to verify therapist: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> rejectTherapist(String id, String reason) async {
    try {
      var url = Uri.parse('$baseUrl/$id/reject'); 
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'reason': reason}), 
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] as String;
      } else {
        throw ServerException(
            message: 'Failed to reject therapist: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
