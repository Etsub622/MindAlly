import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/resource/domain/entity/book_entity.dart';
import 'package:front_end/features/resource/presentation/bloc/book_bloc/bloc/book_bloc.dart';
import 'package:front_end/features/resource/presentation/screens/add_book.dart';
import 'package:front_end/features/resource/presentation/screens/update_book.dart';
import 'package:front_end/features/resource/presentation/widget/book_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookResource extends StatefulWidget {
  final String? currentUserRole;
  const BookResource({super.key, this.currentUserRole});

  @override
  State<BookResource> createState() => _BookResourceState();
}

class _BookResourceState extends State<BookResource> {
  String? currentUserId;
  String? currentUserRole;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BookBloc>().add(GetBookEvent());
    _loadCurrentUserId();
  }

  void _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_profile');
    if (userJson != null) {
      final userMap = json.decode(userJson);
      setState(() {
        print('userMap: $userMap');

        currentUserId = userMap["_id"] ?? '';
        currentUserRole = userMap["Role"];
        print('userId:$currentUserId');
        print('role : $currentUserRole');
      });
    } else {
      print('No user profile found in shared preferences');
    }
  }

  List<String> bookCategories = const [
    'Depression',
    'Anxiety',
    'OCD',
    'General',
    'Trauma',
    'SelfLove'
  ];
  String? selectedCategory;

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
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E1E1),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for books...',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(239, 130, 5, 220),
                      ),
                      border: InputBorder.none,
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
                IconButton(
                  icon: const Icon(Icons.search, size: 24, color: Colors.grey),
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
              icon: const Icon(Icons.refresh,
                  color: Color.fromARGB(239, 130, 5, 220)),
              onPressed: () {
                _searchController.clear();
                context.read<BookBloc>().add(GetBookEvent());
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list,
                  color: Color.fromARGB(239, 130, 5, 220)),
              onOpened: () {
               
                FocusScope.of(context).unfocus();
              },
              onSelected: (String newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
                context
                    .read<BookBloc>()
                    .add(SearchBookByCategoryEvent(newValue));
              },
              itemBuilder: (BuildContext context) {
                return bookCategories.map((String category) {
                  return PopupMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Color.fromARGB(239, 130, 5, 220),
                      ),
                    ),
                  );
                }).toList();
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
                            ownerId: book.ownerId,
                            onUpdate: (updatedBookMap) {
                              final updatedBook = BookEntity(
                                type: book.type,
                                id: book.id,
                                title: updatedBookMap['title'] as String,
                                author: updatedBookMap['author'] as String,
                                image: updatedBookMap['imageUrl'] as String,
                                categories: book.categories,
                                ownerId: book.ownerId,
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
                    currentUserId: currentUserId ?? '',
                    ownerId: book.ownerId,
                    role: currentUserRole ?? '',
                  );
                },
              );
            }
            return const Center(child: Text('Something went wrong!'));
          },
        ),
        floatingActionButton:
            (currentUserId != null && currentUserRole == 'therapist')
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBook()),
                      );
                    },
                    child: const Icon(Icons.add),
                    backgroundColor:Theme.of(context).colorScheme.primary,
                  )
                : null,
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
