import 'package:bloc/bloc.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/Q&A/domain/entity/question_entity.dart';
import 'package:front_end/features/Q&A/domain/usecase/question_usecase.dart';
import 'package:meta/meta.dart';

part 'question_event.dart';
part 'question_state.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final GetQuestionsUsecase getQuestionsUsecase;
  final CreateQuestionUsecase createQuestionUsecase;
  final UpdateQuestionUsecase updateQuestionUsecase;
  final DeleteQuestionUsecase deleteQuestionUsecase;
  final GetQuestionByCatetoryUsecase getQuestionByCategoryUsecase;
  QuestionBloc({
    required this.getQuestionsUsecase,
    required this.createQuestionUsecase,
    required this.updateQuestionUsecase,
    required this.deleteQuestionUsecase,
    required this.getQuestionByCategoryUsecase,
  }) : super(QuestionInitial()) {

    on<AddQuestionEvent>((event, emit)async {
      emit (QuestionLoading());
      final question = await createQuestionUsecase(CreateQuestionParams(event.questionEntity));
      question.fold((l) {
        emit(QuestionError(l.message));
      }, (r) {
        emit(QuestionAdded(r));
      });

    });


    on<GetQuestionEvent>((event, emit) async {
      emit(QuestionLoading());
      final question = await getQuestionsUsecase(NoParams());
      question.fold((l) {
        emit(QuestionError(l.message));
      }, (questions) {
        emit(QuestionLoaded(questions));
      });
    });

    on<UpdateQuestionEvent>((event, emit) async {
      emit(QuestionLoading());
      final result = await updateQuestionUsecase(UpdateQuestionParams(event.questionEntity, event.id));

      result.fold((l) {
        emit(QuestionError(l.message));
      }, (successMessage) {
        emit(QuestionUpdated(successMessage));
      });
    });

    on<DeleteQuestionEvent>((event, emit) async {
      emit(QuestionLoading());
      final result = await deleteQuestionUsecase(DeleteQuestionParams(event.id));

      result.fold((l) {
        emit(QuestionError(l.message));
      }, (successMessage) {
        emit(QuestionDeleted(successMessage));
      });
    });

    on<SearchQuestionEvent>((event, emit) async {
      emit(QuestionLoading());
      final question = await getQuestionByCategoryUsecase(GetQuestionByCategoryParams(event.title));
      question.fold((l) {
        emit(QuestionError(l.message));
      }, (questions) {
        emit(QuestionLoaded(questions));
      });
    });
  }
}
