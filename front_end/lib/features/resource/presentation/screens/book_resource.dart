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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(GetBookEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 226, 225, 225),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for books..',
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(239, 130, 5, 220),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10.0),
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(239, 130, 5, 220),
                      ),
                      onSubmitted: (query) {
                        if (query.isNotEmpty) {
                          context.read<BookBloc>().add(SearchEvent(query));
                        }
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, size: 27, color: Colors.grey),
                  onPressed: () {
                    final query = _searchController.text;
                    if (query.isNotEmpty) {
                      context.read<BookBloc>().add(SearchEvent(query));
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Color.fromARGB(239, 130, 5, 220),
                size: 25,
              ),
              onPressed: () {
                _searchController.clear();
                context.read<BookBloc>().add(GetBookEvent());
              },
            ),
          ],
        ),
        body: BlocConsumer<BookBloc, BookState>(
          listener: (context, state) {
            if (state is BookError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is BookDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Book deleted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<BookBloc>().add(GetBookEvent());
            }
          },
          builder: (context, state) {
            if (state is BookLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchFailed) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is BookLoaded) {
              final books = state.books;
              if (books.isEmpty) {
                return const Center(child: Text('No books available.'));
              }
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
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
                            id: book.id,
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
                    book: book,
                  );
                },
              );
            }
            return const Center(child: Text('Something went wrong!'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddBook()),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
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
