part of 'book_bloc.dart';

@immutable
sealed class BookEvent {
  const BookEvent();
}

class AddBookEvent extends BookEvent {
  final BookEntity bookEntity;
  AddBookEvent(this.bookEntity);
}

class GetBookEvent extends BookEvent {
  const GetBookEvent();
}

class DeleteBookEvent extends BookEvent {
  final String id;
  DeleteBookEvent(this.id);
}

class UpdateBookEvent extends BookEvent {
  final BookEntity bookEntity;
  final String id;
  UpdateBookEvent(this.bookEntity, this.id);
}

class SearchEvent extends BookEvent {
  final String title;
  SearchEvent(this.title);
}

class GetSingleBookEvent extends BookEvent {
  final String id;
  GetSingleBookEvent(this.id);
}