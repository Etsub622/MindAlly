import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/resource/domain/entity/book_entity.dart';
import 'package:front_end/features/resource/domain/repository/book_repository.dart';

class GetBooksUsecase extends Usecase<List<BookEntity>, NoParams> {
  final BookRepository repository;

  GetBooksUsecase(this.repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) async {
    return await repository.getBooks();
  }
}
class GetSingleBookUsecase extends Usecase<BookEntity, SingleBookParams> {
  final BookRepository repository;

  GetSingleBookUsecase(this.repository);

  @override
  Future<Either<Failure, BookEntity>> call(SingleBookParams params) async {
    return await repository.getSingleBook(params.id);
  }
}
class SingleBookParams {
  final String id;
  SingleBookParams(this.id);
}

class AddBookUsecase extends Usecase<String, AddBookParams> {
  final BookRepository repository;
  AddBookUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(AddBookParams params) async {
    return await repository.addBook(params.bookEntity);
  }
}

class AddBookParams {
  final BookEntity bookEntity;
  AddBookParams(this.bookEntity);
}

class DeleteBookUsecase extends Usecase<String, DeleteParams> {
  final BookRepository repository;
  DeleteBookUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteParams params) async {
    return await repository.deleteBook(params.id);
  }
}

class DeleteParams {
  final String id;
  DeleteParams(this.id);
}

class UpdateBookUsecase extends Usecase<String, UpdateParams> {
  final BookRepository repository;
  UpdateBookUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(UpdateParams params) async {
    return await repository.updateBook(params.updateEntity, params.id);
  }
}

class UpdateParams {
  final BookEntity updateEntity;
  final String id;
  UpdateParams(this.updateEntity,this.id);
}

class SearchBookUsecase extends Usecase<List<BookEntity>, SearchParams> {
  final BookRepository repository;
  SearchBookUsecase(this.repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(SearchParams params) async {
    return await repository.searchBook(params.title);
  }
}

class SearchParams {
  final String title;
  SearchParams(this.title);
}
