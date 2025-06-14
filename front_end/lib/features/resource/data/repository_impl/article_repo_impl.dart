import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/exception.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/network/network.dart';
import 'package:front_end/features/resource/data/datasource/remote_datasource/article_remote_datasource.dart';
import 'package:front_end/features/resource/data/model/article_model.dart';
import 'package:front_end/features/resource/domain/entity/article_entity.dart';
import 'package:front_end/features/resource/domain/repository/article_repository.dart';

class ArticleRepoImpl implements ArticleRepository {
  final ArticleRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  ArticleRepoImpl( this.remoteDatasource, this.networkInfo);

  @override
  Future<Either<Failure, String>> addArticle(ArticleEntity article) async {
    // if (await networkInfo.isConnected) {
      try {
        final newArticle = ArticleModel(
          id: '',
          type: 'Article',
          title: article.title,
          content: article.content,
          link: article.link,
          logo: article.logo,
          categories: article.categories,
          ownerId: article.ownerId,
        );
        final res = await remoteDatasource.addArticle(newArticle);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    // } else {
    //   return Left(NetworkFailure(message: 'you are not connected to the internet'));
    // }
  }

  @override
  Future<Either<Failure, String>> deleteArticle(String id) async {
    // if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.deleteArticle(id);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    // } else {
    //   return Left(NetworkFailure(message: 'you are not connected to the internet'));
    // }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getArticles() async {
    // if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.getArticles();
        final articleEntities = res.map((article) => article.toEntity()).toList();
        return Right(articleEntities);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    // } else {
    //   return Left(NetworkFailure(message: 'you are not connected to the internet'));
    // }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> searchArticle(String title) async {
    // if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.searchArticles(title);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    // } else {
    //   return Left(NetworkFailure(message: 'you are not connected to the internet'));
    // }
  }

  @override
  Future<Either<Failure, String>> updateArticle(ArticleEntity article, String id) async {
    // if (await networkInfo.isConnected) {
      try {
        final updatedArticle = ArticleModel(
          id: '',
          type: 'Article',
          title: article.title,
          content: article.content,
          link: article.link,
          logo: article.logo,
          categories: article.categories,
          ownerId: article.ownerId,
        );
        final res = await remoteDatasource.updateArticle(updatedArticle, id);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    // } else {
    //   return Left(NetworkFailure(message: 'you are not connected to the internet'));
    // }
  }
  
  @override
  Future<Either<Failure, ArticleEntity>> getSingleArticle(String id) async{
    // if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.getSingleArticle(id);
        return Right(res);
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    // } else {
    //   return Left(NetworkFailure(message: 'you are not connected to the internet'));
    // }

  }
  
  @override
  Future<Either<Failure, List<ArticleEntity>>> getArticleByCategory(String category)async {
    if (await networkInfo.isConnected) {
      try {
        final res = await remoteDatasource.searchArticleByCategory(category);
        final articleEntities = res.map((article) => article.toEntity()).toList();
        return Right(articleEntities);
    
      } on ServerException {
        return Left(ServerFailure(message: 'server failure'));
      }
    } else {
      return Left(NetworkFailure(message: 'you are not connected to the internet'));
    }
  }
}