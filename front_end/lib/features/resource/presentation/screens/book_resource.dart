import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/resource/domain/entity/book_entity.dart';
import 'package:front_end/features/resource/presentation/bloc/book_bloc/bloc/book_bloc.dart';
import 'package:front_end/features/resource/presentation/screens/add_book.dart';
import 'package:front_end/features/resource/presentation/screens/update_book.dart';
import 'package:front_end/features/resource/presentation/widget/book_card.dart';

class BookResource extends StatefulWidget {
  const BookResource({super.key});

  @override
  State<BookResource> createState() => _BookResourceState();
}

class _BookResourceState extends State<BookResource> {
  @override
  void initState() {
    super.initState();

    context.read<BookBloc>().add(GetBookEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Color.fromARGB(239, 130, 5, 220),
                size: 25,
              ),
              onPressed: () {
                context.read<BookBloc>().add(GetBookEvent());
              },
            ),
          ),
        ],
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BookError) {
            return Center(child: Text(state.message));
          } else if (state is BookLoaded) {
            final books = state.books;
            if (books.isEmpty) {
              return Center(child: Text('No books available.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16), // Add padding around the grid
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16, // Horizontal space between items
                mainAxisSpacing: 16, // Vertical space between items
                childAspectRatio: 0.75, // Adjust the aspect ratio of items
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookItem(
                    onUpdate: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateBook(
                            title: book.title,
                            author: book.author,
                            imageUrl: book.image,
                            categories: book.categories,
                            onUpdate: (updatedBookMap) {
                              final updatedBook = BookEntity(
                                type: book.type,
                                id: book.id,
                                title: updatedBookMap['title'] as String,
                                author: updatedBookMap['author'] as String,
                                image: updatedBookMap['imageUrl'] as String,
                                categories: book.categories,
                              );
                              context
                                  .read<BookBloc>()
                                  .add(UpdateBookEvent(updatedBook, book.id));
                            },
                          ),
                        ),
                      );

                      if (result == true) {
                        context
                            .read<BookBloc>()
                            .add(GetSingleBookEvent(book.id));
                      }
                    },
                    onDelete: () {
                      _showDeleteDialog(context, book.id);
                    },
                    book: book);
              },
            );
          } else {
            return Center(child: Text('Something went wrong!'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBook()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete this book?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<BookBloc>().add(DeleteBookEvent(id));
                Navigator.of(context).pop();
                context.read<BookBloc>().add(GetBookEvent());
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
