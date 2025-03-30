import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/resource/domain/entity/article_entity.dart';
import 'package:front_end/features/resource/presentation/bloc/article_bloc/bloc/article_bloc.dart';
import 'package:front_end/features/resource/presentation/screens/add_article.dart';
import 'package:front_end/features/resource/presentation/screens/update_article.dart';
import 'package:front_end/features/resource/presentation/widget/article_card.dart';

class ArticleResource extends StatefulWidget {
  const ArticleResource({super.key});

  @override
  State<ArticleResource> createState() => _ArticleResourceState();
}

class _ArticleResourceState extends State<ArticleResource> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    context.read<ArticleBloc>().add(GetArticleEvent());
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
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for articles...',
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
                          context
                              .read<ArticleBloc>()
                              .add(SearchArticleEvent(query));
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
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Color.fromARGB(239, 130, 5, 220),
                  size: 25,
                ),
                onPressed: () {
                  context.read<ArticleBloc>().add(GetArticleEvent());
                },
              ),
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
                    ),
                  );
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
              MaterialPageRoute(builder: (context) => AddArticle()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
      ),
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
