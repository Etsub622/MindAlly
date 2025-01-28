import 'dart:convert';

import 'package:front_end/core/error/exception.dart';
import 'package:front_end/features/resource/data/model/book_model.dart';
import 'package:http/http.dart' as http;

abstract class BookRemoteDatasource {
  Future<List<BookModel>> getBooks();
  Future<String> addBook(BookModel book);
  Future<String> updateBook(BookModel book,String id);
  Future<String> deleteBook(String id);
  Future<List<BookModel>> searchBooks(String title);
}

class BookRemoteDataSourceImpl implements BookRemoteDatasource {
  final http.Client client;
  BookRemoteDataSourceImpl(this.client);

  final baseUrl = 'http://localhost:3000/addBook';

  @override
  Future<String> addBook(BookModel book) async {
    try {
      var url = Uri.parse('$baseUrl/addBook');
      final newBook = await client.post(url, body: jsonEncode(book.toJson()));
      if (newBook.statusCode == 200) {
        final decodedResponse = jsonDecode(newBook.body);
        return decodedResponse['message'];
      } else {
        throw ServerException(
            message: 'Failed to add book:${newBook.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> deleteBook(String id) async {
    try {
      var url = Uri.parse('$baseUrl/deleteBook/$id');
      final deletedBook = await client.delete(url);
      if (deletedBook.statusCode == 200) {
        final decodedResponse = jsonDecode(deletedBook.body);
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
      var url = Uri.parse('baseUrl/getBooks');
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
  Future<String> updateBook(BookModel book,String id) async {
    try {
      var url = Uri.parse('$baseUrl/updateBook/$id');
      final updatedBook =
          await client.put(url, body: jsonEncode(book.toJson()));

      if (updatedBook.statusCode == 200) {
        final decodedResponse = jsonDecode(updatedBook.body);
        return decodedResponse['message'];
      } else {
        throw ServerException(
            message: 'Failed to update book:${updatedBook.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
