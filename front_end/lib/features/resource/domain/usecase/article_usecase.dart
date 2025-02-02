import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/resource/domain/entity/article_entity.dart';
import 'package:front_end/features/resource/domain/repository/article_repository.dart';


class GetArticlesUsecase extends Usecase<List<ArticleEntity>, NoParams> {
  final ArticleRepository repository;

  GetArticlesUsecase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(NoParams params) async {
    return await repository.getArticles();
  }
}



class AddArticleUsecase extends Usecase<String, AddArticleParams> {
  final ArticleRepository repository;
  AddArticleUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(AddArticleParams params) async {
    return await repository.addArticle(params.articleEntity);
  }
}
class AddArticleParams {
  final ArticleEntity articleEntity;
  AddArticleParams(this.articleEntity);
}



class UpdateArticleUsecase extends Usecase<String, UpdateArticleParams> {
  final ArticleRepository repository;
  UpdateArticleUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(UpdateArticleParams params) async {
    return await repository.updateArticle(params.updateEntity, params.id);
  }
}
class UpdateArticleParams {
  final ArticleEntity updateEntity;
  final String id;
  UpdateArticleParams(this.updateEntity, this.id);
}



class DeleteArticleUsecase extends Usecase<String, DeleteArticleParams> {
  final ArticleRepository repository;
  DeleteArticleUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(DeleteArticleParams params) async {
    return await repository.deleteArticle(params.id);
  }
}

class DeleteArticleParams {
  final String id;
  DeleteArticleParams(this.id);
}



class SearchArticleUsecase extends Usecase<List<ArticleEntity>, SearchArticleParams> {
  final ArticleRepository repository;
  SearchArticleUsecase(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(SearchArticleParams params) async {
    return await repository.searchArticle(params.title);
  }
}

class SearchArticleParams {
  final String title;
  SearchArticleParams(this.title);
}