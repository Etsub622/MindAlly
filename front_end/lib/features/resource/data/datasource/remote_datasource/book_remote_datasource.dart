import 'dart:convert';

import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/resource/data/model/book_model.dart';
import 'package:http/http.dart' as http;

abstract class BookRemoteDatasource {
  Future<List<BookModel>> getBooks();
  Future<String> addBook(BookModel book);
  Future<String> updateBook(BookModel book, String id);
  Future<String> deleteBook(String id);
  Future<List<BookModel>> searchBooks(String title);
  Future<BookModel> getSingleBook(String id);
}

class BookRemoteDataSourceImpl implements BookRemoteDatasource {
  final http.Client client;
  BookRemoteDataSourceImpl(this.client);

  final baseUrl = 'http://10.0.2.2:8000/api/resources';

  @override
  Future<String> addBook(BookModel book) async {
    try {
      var url = Uri.parse(baseUrl);
      final newBook = await client.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(book.toJson()));
      print(newBook.statusCode);
      print(newBook.body);
      if (newBook.statusCode == 201) {
        return 'Book added successfully';
      } else {
        throw ServerException(
            message: 'Failed to add book:${newBook.statusCode}');
      }
    } catch (e) {
      print(e.toString());
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> deleteBook(String id) async {
    try {
      var url = Uri.parse('$baseUrl/$id');
      final deletedBook = await client.delete(url);
      print(deletedBook.statusCode);
      if (deletedBook.statusCode == 200) {
        final decodedResponse = jsonDecode(deletedBook.body);
        print(decodedResponse['message']);
        return decodedResponse['message'];
      } else {
        throw ServerException(
            message: 'Failed to delete book:${deletedBook.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookModel>> getBooks() async {
    try {
      var url = Uri.parse(baseUrl);
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final List<dynamic> bookJson = json.decode(response.body);
        if (bookJson.isEmpty) {
          return [];
        } else {
          return bookJson.map((jsonItem) {
            return BookModel.fromJson(jsonItem as Map<String, dynamic>);
          }).toList();
        }
      } else {
        throw ServerException(
            message: 'Failed to get books:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookModel>> searchBooks(String title) async {
    try {
      var url = Uri.parse('$baseUrl/searchBooks/$title');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final List<dynamic> bookJson = json.decode(response.body);
        if (bookJson.isEmpty) {
          throw ServerException(message: 'No books found');
        } else {
          return bookJson.map((jsonItem) {
            return BookModel.fromJson(jsonItem as Map<String, dynamic>);
          }).toList();
        }
      } else {
        throw ServerException(
            message: 'Failed to get books:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> updateBook(BookModel book, String id) async {
    try {
      var url = Uri.parse('$baseUrl/$id');
      final updatedBook =
          await client.put(url, body: jsonEncode(book.toJson()));

      if (updatedBook.statusCode == 200) {
        // final decodedResponse = jsonDecode(updatedBook.body);
        return 'Book Updated Successfully';
      } else {
        throw ServerException(
            message: 'Failed to update book:${updatedBook.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<BookModel> getSingleBook(String id) async {
    try {
      var url = Uri.parse('$baseUrl/getSingleBook/$id');
      final response = await client.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> bookJson = json.decode(response.body);
        return BookModel.fromJson(bookJson);
      } else {
        throw ServerException(
            message: 'Failed to get book:${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
