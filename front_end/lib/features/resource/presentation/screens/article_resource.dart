import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/resource/domain/entity/article_entity.dart';
import 'package:front_end/features/resource/presentation/bloc/article_bloc/bloc/article_bloc.dart';
import 'package:front_end/features/resource/presentation/screens/add_article.dart';
import 'package:front_end/features/resource/presentation/screens/update_article.dart';
import 'package:front_end/features/resource/presentation/widget/article_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleResource extends StatefulWidget {
  final String? currentUserRole;
  const ArticleResource({super.key, this.currentUserRole});

  @override
  State<ArticleResource> createState() => _ArticleResourceState();
}

class _ArticleResourceState extends State<ArticleResource> {
  String? currentUserId;
  String? currentUserRole;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    context.read<ArticleBloc>().add(GetArticleEvent());
    _loadCurrentUserId();
  }

  List<String> articleCategories = const [
    'Depression',
    'Anxiety',
    'OCD',
    'General',
    'Trauma',
    'SelfLove'
  ];
  String? selectedCategory;

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
                        hintText: 'Search for articles...',
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
                          context
                              .read<ArticleBloc>()
                              .add(SearchArticleEvent(query));
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.search, size: 24, color: Colors.grey),
                    onPressed: () {
                      final query = _searchController.text;
                      if (query.isNotEmpty) {
                        context
                            .read<ArticleBloc>()
                            .add(SearchArticleEvent(query));
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
                  FocusScope.of(context).unfocus(); // hide keyboard
                  _searchController.clear();
                  context.read<ArticleBloc>().add(GetArticleEvent());
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list,
                    color: Color.fromARGB(239, 130, 5, 220)),
                onOpened: () {
                  FocusScope.of(context).unfocus(); // dismiss keyboard
                },
                onSelected: (String newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                  context
                      .read<ArticleBloc>()
                      .add(SearchArticleByCategoryEvent(newValue));
                },
                itemBuilder: (BuildContext context) {
                  return articleCategories.map((String category) {
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
          body: BlocConsumer<ArticleBloc, ArticleState>(
            listener: (context, state) {
              if (state is ArticleDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Article deleted successfully!'),
                  backgroundColor: Colors.green,
                ));
                context.read<ArticleBloc>().add(GetArticleEvent());
              } else if (state is ArticleError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
              }
            },
            builder: (context, state) {
              if (state is ArticleLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is SearchFailed) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              } else if (state is ArticleLoaded) {
                final articles = state.articles;
                if (articles.isEmpty) {
                  return Center(child: Text('No articles available.'));
                }
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ArticleCard(
                        onUpdate: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateArticle(
                                id: article.id,
                                title: article.title,
                                content: article.content,
                                logo: article.logo,
                                link: article.link,
                                categories: article.categories,
                                ownerId: article.ownerId,
                                onUpdate: (updatedArticleMap) {
                                  final updatedArticle = ArticleEntity(
                                    type: article.type,
                                    id: article.id,
                                    title: updatedArticleMap['title'] as String,
                                    content:
                                        updatedArticleMap['content'] as String,
                                    logo: updatedArticleMap['logo'] as String,
                                    link: updatedArticleMap['link'] as String,
                                    categories: article.categories,
                                    ownerId: article.ownerId,
                                  );
                                  context.read<ArticleBloc>().add(
                                      UpdateArticleEvent(
                                          updatedArticle, article.id));
                                },
                              ),
                            ),
                          );

                          if (result == true) {
                            context
                                .read<ArticleBloc>()
                                .add(GetSingleArticleEvent(article.id));
                          }
                        },
                        onDelete: () {
                          _showDeleteDialog(context, article.id);
                        },
                        article: article,
                        currentUserId: currentUserId ?? '',
                        ownerId: article.ownerId,
                        role: currentUserRole ?? '',
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text('Something went wrong!'));
              }
            },
          ),
          floatingActionButton:
              (currentUserId != null && currentUserRole == 'therapist')
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddArticle()),
                        );
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    )
                  : null),
    );
  }

  void _showDeleteDialog(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete this article?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ArticleBloc>().add(DeleteArticleEvent(id));
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
