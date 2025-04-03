import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/resource/domain/entity/book_entity.dart';

abstract interface class BookRepository {
  Future<Either<Failure, List<BookEntity>>> getBooks();
  Future<Either<Failure, String>> addBook(BookEntity book);
  Future<Either<Failure, String>> updateBook(BookEntity book, String id);
  Future<Either<Failure, String>> deleteBook(String id);
  Future<Either<Failure, List<BookEntity>>> searchBook(String title);
  Future<Either<Failure, BookEntity>> getSingleBook(String id);
  Future<Either<Failure, List<BookEntity>>> getBookByCategory(String category);
}

