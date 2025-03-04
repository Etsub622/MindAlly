import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/resource/data/datasource/remote_datasource/book_remote_datasource.dart';
import 'package:front_end/features/resource/data/model/book_model.dart';
import 'package:front_end/features/resource/domain/entity/book_entity.dart';
import 'package:front_end/features/resource/domain/repository/book_repository.dart';

class BookRepoImpl implements BookRepository {
  final BookRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;
  BookRepoImpl(this.networkInfo, this.remoteDatasource);

  @override
  Future<Either<Failure, String>> addBook(BookEntity book) async {
    print('is inknkkkkkkkkkkkkkk');
    if (await networkInfo.isConnected) {
      print('uguguguiiguu');
      try {
        final newBook = BookModel(
          id:'',
            type: 'Book',
            title: book.title,
            author: book.author,
            image: book.image,
            categories: book.categories);
        final res = await remoteDatasource.addBook(newBook);
        print(res);
        print(newBook);
        return right(res);
      } on ServerException {
        return (Left(ServerFailure(message: 'server failure')));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }

  @override
  Future<Either<Failure, String>> deleteBook(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.deleteBook(id);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> getBooks() async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.getBooks();
        final bookEntities = res.map((book) => book.toEntity()).toList();
        return Right(bookEntities);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'You are not connected to the internet.'));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> searchBook(String title) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.searchBooks(title);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'you are not corrected to the internet.'));
    }
  }

  @override
  Future<Either<Failure, String>> updateBook(BookEntity book, String id) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedBook = BookModel(
          id:'',
            type: 'Book',
            title: book.title,
            author: book.author,
            image: book.image,
            categories: book.categories);
        final res = remoteDatasource.updateBook(updatedBook, id);
        return Right(res as String);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'you are not connected to the internet.'));
    }
  }
  
  @override
  Future<Either<Failure, BookEntity>> getSingleBook(String id) async{
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.getSingleBook(id);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(
          NetworkFailure(message: 'you are not connected to the internet.'));
    }
   
  }
  
  @override
  Future<Either<Failure, List<BookEntity>>> getBookByCategory(String category) {
    // TODO: implement getBookByCategory
    throw UnimplementedError();
  }
}
