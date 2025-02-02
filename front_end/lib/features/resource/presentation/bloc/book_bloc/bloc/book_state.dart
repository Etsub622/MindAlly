part of 'book_bloc.dart';

@immutable
sealed class BookState {}

final class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<BookEntity> books;
  BookLoaded(this.books);
}

class BookError extends BookState {
  final String message;
  BookError(this.message);
}

class BookAdded extends BookState {
  final String message;
  BookAdded(this.message);
}

class BookUpdated extends BookState {
  final String message;
  BookUpdated(this.message);
}

class BookDeleted extends BookState {
  final String message;
  BookDeleted(this.message);
}

class SearchLoaded extends BookState {
  final List<BookEntity> books;
  SearchLoaded(this.books);
}
class SingleBookLoaded extends BookState {
  final BookEntity book;
  SingleBookLoaded(this.book);
}