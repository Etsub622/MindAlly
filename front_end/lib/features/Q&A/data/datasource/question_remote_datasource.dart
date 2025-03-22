import 'dart:convert';
import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/Q&A/data/model/question_model.dart';
import 'package:http/http.dart' as http;

abstract class QuestionRemoteDatasource {
  Future<List<QuestionModel>> getQuestions();
  Future<String> addQuestion(QuestionModel question);
  Future<String> updateQuestion(QuestionModel question, String id);
  Future<String> deleteQuestion(String id);
  Future<List<QuestionModel>> getQuestionbyCategory(String category);
}

class QuestionRemoteDataSourceImpl implements QuestionRemoteDatasource {
  final http.Client client;
  QuestionRemoteDataSourceImpl(this.client);

  final baseUrl = ConfigKey.baseUrl;

  @override
  Future<String> addQuestion(QuestionModel question) async {
    try {
      var url = Uri.parse('$baseUrl/questions');
      final newQuestion = await client.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(question.toJson()));
      print(newQuestion.statusCode);
      print(newQuestion.body);
      if (newQuestion.statusCode == 201) {
        return 'Question added successfully';
      } else {
        throw ServerException(
            message: 'Failed to add question:${newQuestion.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> deleteQuestion(String id) async {
    try {
      var url = Uri.parse('$baseUrl/questions/$id');
      final deletedQuestion = await client.delete(url);
      if (deletedQuestion.statusCode == 200) {
        final decodedResponse = jsonDecode(deletedQuestion.body);
        return decodedResponse['message'];
      } else {
        throw ServerException(
            message: 'Failed to delete question:${deletedQuestion.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<QuestionModel>> getQuestionbyCategory(String category) async {
    try {
      var url = Uri.parse('$baseUrl/getQuestionsByCategory/$category');
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return decodedResponse['message'];
      } else {
        throw ServerException(
            message: 'Failed to get question:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<QuestionModel>> getQuestions() async {
    try {
      var url = Uri.parse('$baseUrl/questions');
      final response = await client.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> questionJson = json.decode(response.body);
        if (questionJson.isEmpty) {
          return [];
        } else {
          return questionJson.map((jsonItem) {
            return QuestionModel.fromJson(jsonItem as Map<String, dynamic>);
          }).toList();
        }
      } else {
        throw ServerException(
            message: 'Failed to get questions:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> updateQuestion(QuestionModel question, String id) async {
    try {
      var url = Uri.parse('$baseUrl/questions/$id');
      final updatedQuestion = await client.put(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(question.toJson()));
      if (updatedQuestion.statusCode == 200) {
        return 'Question updated successfully';
      } else {
        throw ServerException(
            message: 'Failed to update question:${updatedQuestion.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
