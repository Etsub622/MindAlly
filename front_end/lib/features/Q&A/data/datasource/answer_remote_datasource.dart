import 'dart:convert';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/Q&A/data/model/answer_model.dart';
import 'package:http/http.dart' as http;

abstract class AnswerRemoteDatasource {
  Future<List<AnswerModel>> getAnswers();
  Future<String> addAnswer(AnswerModel answer);
  Future<String> updateAnswer(AnswerModel answer, String id);
  Future<String> deleteAnswer(String id);
}

class AnswerRemoteDataSourceImpl implements AnswerRemoteDatasource {
  final http.Client client;
  AnswerRemoteDataSourceImpl(this.client);

  final baseUrl = 'http://192.168.83.216:8000/api/forum';

  @override
  Future<String> addAnswer(AnswerModel answer) async {
    try {
      var url = Uri.parse('$baseUrl/createAnswer');
      final newAnswer = await client.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(answer.toJson()));

      if (newAnswer.statusCode == 201) {
        return 'Answer added successfully';
      } else {
        throw ServerException(
            message: 'Failed to add answer:${newAnswer.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> deleteAnswer(String id) async{
    try {
      var url = Uri.parse('$baseUrl/deleteAnswer/$id');
      final deletedAnswer = await client.delete(url);
      if (deletedAnswer.statusCode == 200) {
        final decodedResponse = jsonDecode(deletedAnswer.body);
        return decodedResponse['message'];
      } else {
        throw ServerException(
            message: 'Failed to delete answer:${deletedAnswer.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<AnswerModel>> getAnswers()async {
    try {
      var url = Uri.parse('$baseUrl/getAnswers');
      final response = await client.get(url);
     if (response.statusCode == 200) {
        final List<dynamic> answerJson = json.decode(response.body);
        if (answerJson.isEmpty) {
          return [];
        } else {
          return answerJson.map((jsonItem) {
            return AnswerModel.fromJson(jsonItem as Map<String, dynamic>);
          }).toList();
        }
      } else {
        throw ServerException(message: 'Failed to get answers:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }

  }

  @override
  Future<String> updateAnswer(AnswerModel answer, String id)async {
    try {
      var url = Uri.parse('$baseUrl/updateAnswer/$id');
      final updatedAnswer = await client.put(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(answer.toJson()));

      if (updatedAnswer.statusCode == 201) {
        return 'Answer updated successfully';
      } else {
        throw ServerException(
            message: 'Failed to update answer:${updatedAnswer.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());

  }
}

}