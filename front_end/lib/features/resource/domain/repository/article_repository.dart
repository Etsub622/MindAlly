import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/features/resource/domain/entity/article_entity.dart';

abstract interface class ArticleRepository {
  Future<Either<Failure, List<ArticleEntity>>> getArticles();
  Future<Either<Failure, String>> addArticle(ArticleEntity article);
  Future<Either<Failure, String>> updateArticle(ArticleEntity article, String id);
  Future<Either<Failure, String>> deleteArticle(String id);
  Future<Either<Failure, List<ArticleEntity>>> searchArticle(String title);
  Future<Either<Failure, ArticleEntity>> getSingleArticle(String id);
  Future<Either<Failure, List<ArticleEntity>>> getArticleByCategory(String category);
}