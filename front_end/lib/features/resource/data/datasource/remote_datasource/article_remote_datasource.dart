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
  Future<List<ArticleModel>> searchArticleByCategory(String category);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDatasource {
  final http.Client client;
  ArticleRemoteDataSourceImpl(this.client) {
    print('ArticleRemoteDataSourceImpl created');
  }

  final baseUrl = '${ConfigKey.baseUrl}/resources';

  @override
  Future<String> addArticle(ArticleModel article) async {
    try {
      var url = Uri.parse(baseUrl);
      final newArticle = await client.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(article.toJson()));
      print(newArticle.statusCode);
      print(newArticle.body);
      if (newArticle.statusCode == 201) {
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
      var url = Uri.parse('$baseUrl/$id');
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
  Future<List<ArticleModel>> getArticles() async {
    try {
      var url = Uri.parse('$baseUrl/type/Article');
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
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw ServerException(
            message: 'Failed to get articles:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ArticleModel>> searchArticles(String title) async {
    try {
      var url = Uri.parse('$baseUrl/search?query=$title');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final List<dynamic> articleJson = json.decode(response.body);
        if (articleJson.isEmpty) {
          return [];
        } else {
          return articleJson.map((jsonItem) {
            return ArticleModel.fromJson(jsonItem as Map<String, dynamic>);
          }).toList();
        }
      } else if (response.statusCode == 404) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final errorMessage =
            errorResponse['message'] ?? 'No matching resources found.';
        print('Error: $errorMessage');
        return [];
      } else {
        throw ServerException(
            message: 'Failed to search articles:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> updateArticle(ArticleModel article, String id) async {
    try {
      var url = Uri.parse('$baseUrl/$id');
      final updatedArticle = await client.put(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(article.toJson()));
      if (updatedArticle.statusCode == 200) {
        return 'Article updated successfully';
      } else {
        throw ServerException(
            message: 'Failed to update article:${updatedArticle.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ArticleModel> getSingleArticle(String id) async {
    try {
      var url = Uri.parse('$baseUrl/getSingleArticle/$id');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return ArticleModel.fromJson(decodedResponse);
      } else {
        throw ServerException(
            message: 'Failed to get single article:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ArticleModel>> searchArticleByCategory(String category) async {
    try {
      var url = Uri.parse('$baseUrl/category/$category');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> articleJson = json.decode(response.body);
        return articleJson.map((jsonItem) {
          return ArticleModel.fromJson(jsonItem as Map<String, dynamic>);
        }).toList();
      } else if (response.statusCode == 404) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final errorMessage =
            errorResponse['message'] ?? 'No articles found in this category.';
        print('Error: $errorMessage');
        return [];
      } else {
        throw ServerException(
            message:
                'Failed to get articles by category: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
