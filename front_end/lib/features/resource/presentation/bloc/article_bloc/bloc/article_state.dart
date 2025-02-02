part of 'article_bloc.dart';

@immutable
sealed class ArticleState {}

final class ArticleInitial extends ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final List<ArticleEntity> articles;
  ArticleLoaded(this.articles);
}

class ArticleError extends ArticleState {
  final String message;
  ArticleError(this.message);
}

class ArticleAdded extends ArticleState {
  final String message;
  ArticleAdded(this.message);
}

class ArticleUpdated extends ArticleState {
  final String message;
  ArticleUpdated(this.message);
}

class ArticleDeleted extends ArticleState {
  final String message;
  ArticleDeleted(this.message);
}

class SearchArticleLoaded extends ArticleState {
  final List<ArticleEntity> articles;
  SearchArticleLoaded(this.articles);
}
