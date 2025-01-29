import 'package:bloc/bloc.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/resource/domain/entity/book_entity.dart';
import 'package:front_end/features/resource/domain/usecase/book_usecase.dart';
import 'package:meta/meta.dart';

part 'book_event.dart';
part 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final AddBookUsecase addBookUsecase;
  final GetBooksUsecase getBooksUsecase;
  final DeleteBookUsecase deleteBookUsecase;
  final UpdateBookUsecase updateBookUsecase;
  final SearchBookUsecase searchBookUsecase;
  BookBloc({
    required this.addBookUsecase,
    required this.deleteBookUsecase,
    required this.getBooksUsecase,
    required this.searchBookUsecase,
    required this.updateBookUsecase,
  }) : super(BookInitial()) {
    on<AddBookEvent>((event, emit) async {
      emit(BookLoading());

      final book = await addBookUsecase(AddBookParams(event.bookEntity));

      book.fold((l) {
        emit(BookError(l.message));
      }, (r) {
        emit(BookAdded(r));
      });
    });

    on<GetBookEvent>((event, emit) async {
      emit(BookLoading());
      final book = await getBooksUsecase(NoParams());
      book.fold((l) {
        emit(BookError(l.message));
      }, (books) {
        emit(BookLoaded(books));
      });
    });

    on<UpdateBookEvent>((event, emit) async {
      emit(BookLoading());
      final result =
          await updateBookUsecase(UpdateParams(event.bookEntity, event.id));

      result.fold((l) {
        emit(BookError(l.message));
      }, (successMessage) {
        emit(BookUpdated(successMessage));
      });
    });

    on<DeleteBookEvent>((event, emit) async {
      emit(BookLoading());

      final book = await deleteBookUsecase(DeleteParams(event.id));

      book.fold((l) {
        emit(BookError(l.message));
      }, (book) {
        emit(BookDeleted('Book deleted'));
      });
    });

    on<SearchEvent>((event, emit) async {
      emit(BookLoading());
      final books = await searchBookUsecase(SearchParams(event.title));

      books.fold((l) => emit(BookError('No book found')),
          (books) => emit(SearchLoaded(books)));
    });
  }
}
