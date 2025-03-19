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
  @override
  void initState() {
    super.initState();

    context.read<ArticleBloc>().add(GetArticleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: BlocBuilder<ArticleBloc, ArticleState>(
        builder: (context, state) {
          if (state is ArticleLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ArticleError) {
            return Center(child: Text(state.message));
          } else if (state is ArticleLoaded) {
            final articles = state.articles;
            if (articles.isEmpty) {
              return Center(child: Text('No articles available.'));
            }
            return GridView.builder(
              padding: EdgeInsets.all(16), 
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16, // Horizontal space between items
                mainAxisSpacing: 16, // Vertical space between items
                childAspectRatio: 0.75, // Adjust the aspect ratio of items
              ),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ArticleCard(
                    onUpdate: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateArticle(
                            title: article.title,
                            content: article.content,
                            logo: article.logo,
                            link: article.link,
                            onUpdate: (updatedArticleMap) {
                              final updatedArticle = ArticleEntity(
                               type: article.type,
                                id: article.id,
                                title: updatedArticleMap['title'] as String,
                                content: updatedArticleMap['content'] as String,
                                logo: updatedArticleMap['logo'] as String,
                                link: updatedArticleMap['link'] as String,
                                categories: article.categories,
                              );
                              context
                                  .read<ArticleBloc>()
                                  .add(UpdateArticleEvent(
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
                    article: article);
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
                Navigator.of(context).pop();
                context.read<ArticleBloc>().add(GetArticleEvent());
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
