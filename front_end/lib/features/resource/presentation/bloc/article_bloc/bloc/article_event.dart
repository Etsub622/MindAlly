part of 'article_bloc.dart';

@immutable
sealed class ArticleEvent {
  const ArticleEvent();
}
class AddArticleEvent extends ArticleEvent{
  final ArticleEntity articleEntity;
  AddArticleEvent(this.articleEntity);
}

class GetArticleEvent extends ArticleEvent{
  const GetArticleEvent();
}

class UpdateArticleEvent extends ArticleEvent{
  final ArticleEntity articleEntity;
  final String id;
  UpdateArticleEvent(this.articleEntity, this.id);
}

class DeleteArticleEvent extends ArticleEvent{
  final String id;
  DeleteArticleEvent(this.id);

  
}

class SearchArticleEvent extends ArticleEvent{
  final String title;
  SearchArticleEvent(this.title);
}

class GetSingleArticleEvent extends ArticleEvent{
  final String id;
  GetSingleArticleEvent(this.id);
}