import 'dart:convert';

import 'package:front_end/core/config/config_key.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/resource/data/model/article_model.dart';
import 'package:http/http.dart' as http;

abstract class ArticleRemoteDatasource {
  Future<List<ArticleModel>> getArticles();
  Future<String> addArticle(ArticleModel article);
  Future<String> updateArticle(ArticleModel article, String id);
  Future<String> deleteArticle(String id);
  Future<List<ArticleModel>> searchArticles(String title);
  Future<ArticleModel> getSingleArticle(String id);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDatasource {
  final http.Client client;
ArticleRemoteDataSourceImpl(this.client){
  print('ArticleRemoteDataSourceImpl created');
}

  final baseUrl = '${ConfigKey.baseUrl}/Article';

  @override
  Future<String> addArticle(ArticleModel article) async {
    try {
      var url = Uri.parse(baseUrl);
      final newArticle =
          await client.post(url, body: jsonEncode(article.toJson()));
      if (newArticle.statusCode == 200) {
        // final decodedResponse = jsonDecode(newArticle.body);
        return 'Article added successfully';
      } else {
        throw ServerException(
            message: 'Failed to add article:${newArticle.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> deleteArticle(String id) async {
    try {
      var url = Uri.parse('$baseUrl/deleteArticle/$id');
      final deletedArticle = await client.delete(url);
      if (deletedArticle.statusCode == 200) {
        final decodedResponse = jsonDecode(deletedArticle.body);
        return decodedResponse['message'];
      } else {
        throw ServerException(
            message: 'Failed to delete article:${deletedArticle.statusCode}');
      }

    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ArticleModel>> getArticles() async{
    try {
      var url = Uri.parse('$baseUrl/getArticles');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final List<ArticleModel> articles = [];
        for (var article in decodedResponse) {
          articles.add(ArticleModel.fromJson(article));
        }
        return articles;
      } else if(response.statusCode == 404){
        return [];
      }else {
        throw ServerException(message: 'Failed to get articles:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
   
  }

  @override
  Future<List<ArticleModel>> searchArticles(String title) async{
    try {
      var url = Uri.parse('$baseUrl/searchArticles/$title');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final List<ArticleModel> articles = [];
        for (var article in decodedResponse) {
          articles.add(ArticleModel.fromJson(article));
        }
        return articles;
      } else {
        throw ServerException(message: 'Failed to search articles:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
    
  }

  @override
  Future<String> updateArticle(ArticleModel article, String id) async{
    try {
      var url = Uri.parse('$baseUrl/updateArticle/$id');
      final updatedArticle =
          await client.put(url, body: jsonEncode(article.toJson()));
      if (updatedArticle.statusCode == 200) {
        final decodedResponse = jsonDecode(updatedArticle.body);
        return decodedResponse['message'];
      } else {
        throw ServerException(
            message: 'Failed to update article:${updatedArticle.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
   
  }
  
  @override
  Future<ArticleModel> getSingleArticle(String id)async {

    try {
      var url = Uri.parse('$baseUrl/getSingleArticle/$id');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return ArticleModel.fromJson(decodedResponse);
      } else {
        throw ServerException(message: 'Failed to get single article:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
   
  }
}

}