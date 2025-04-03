import 'package:bloc/bloc.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/resource/domain/entity/article_entity.dart';
import 'package:front_end/features/resource/domain/usecase/article_usecase.dart';
import 'package:meta/meta.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final AddArticleUsecase addArticleUsecase;
  final GetArticlesUsecase getArticlesUsecase;
  final DeleteArticleUsecase deleteArticleUsecase;
  final SearchArticleUsecase searchArticleUsecase;
  final UpdateArticleUsecase updateArticleUsecase;
  final GetSingleArticleUsecase getSingleArticleUsecase;
  ArticleBloc({
    required this.addArticleUsecase,
    required this.deleteArticleUsecase,
    required this.getArticlesUsecase,
    required this.searchArticleUsecase,
    required this.updateArticleUsecase,
    required this.getSingleArticleUsecase,
  }) : super(ArticleInitial()) {
    on<AddArticleEvent>((event, emit) async {
      emit(ArticleLoading());

      final article =
          await addArticleUsecase(AddArticleParams(event.articleEntity));

      article.fold((l) {
        emit(ArticleError(l.message));
      }, (r) {
        emit(ArticleAdded(r));
      });
    });

    on<GetArticleEvent>((event, emit) async {
      emit(ArticleLoading());
      final article = await getArticlesUsecase(NoParams());
      article.fold((l) {
        emit(ArticleError(l.message));
      }, (articles) {
        emit(ArticleLoaded(articles));
      });
    });

    on<UpdateArticleEvent>((event, emit) async {
      emit(ArticleLoading());
      final result = await updateArticleUsecase(
          UpdateArticleParams(event.articleEntity, event.id));

      result.fold((l) {
        emit(ArticleError(l.message));
      }, (successMessage) {
        emit(ArticleUpdated(successMessage));
      });
    });

    on<DeleteArticleEvent>((event, emit) async {
      emit(ArticleLoading());
      final result = await deleteArticleUsecase(DeleteArticleParams(event.id));

      result.fold((l) {
        emit(ArticleError(l.message));
      }, (successMessage) {
        emit(ArticleDeleted(successMessage));
      });
    });

    on<SearchArticleEvent>((event, emit) async {
      emit(ArticleLoading());

      final result =
          await searchArticleUsecase(SearchArticleParams(event.title));

      result.fold(
        (failure) {
          emit(SearchFailed(failure.message));
        },
        (articles) {
          if (articles.isEmpty) {
            emit(SearchFailed('No resources found'));
          } else {
            emit(ArticleLoaded(articles));
          }
        },
      );
    });

    on<GetSingleArticleEvent>((event, emit) async {
      emit(ArticleLoading());
      final result =
          await getSingleArticleUsecase(GetSingleArticleParams(event.id));

      result.fold((l) {
        emit(ArticleError(l.message));
      }, (article) {
        emit(SingleArticleLoaded(article));
      });
    });
  }
}
