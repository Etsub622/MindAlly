import 'package:bloc/bloc.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/Q&A/domain/entity/answer_entity.dart';
import 'package:front_end/features/Q&A/domain/usecase/answer_usecase.dart';
import 'package:meta/meta.dart';

part 'answer_event.dart';
part 'answer_state.dart';

class AnswerBloc extends Bloc<AnswerEvent, AnswerState> {
  final GetAnswersUsecase getAnswersUsecase;
  final AddAnswerUsecase addAnswerUsecase;
  final DeleteAnswerUsecase deleteAnswerUsecase;
  final UpdateAnswerUsecase updateAnswerUsecase;
  AnswerBloc({
    required this.getAnswersUsecase,
    required this.deleteAnswerUsecase,
    required this.addAnswerUsecase,
    required this.updateAnswerUsecase,
  }) : super(AnswerInitial()) {
    
    on<AddAnswerEvent>((event, emit) async {
      emit(AnswerLoading());
      final answer =
          await addAnswerUsecase(AddAnswerParams(event.answerEntity));
      answer.fold((l) {
        emit(AnswerError(l.message));
      }, (r) {
        emit(AnswerAdded(r));
      });
    });

    on<GetAnswerEvent>((event, emit) async {
      emit(AnswerLoading());
      final answer = await getAnswersUsecase(NoParams());
      answer.fold((l) {
        emit(AnswerError(l.message));
      }, (answers) {
        emit(AnswerLoaded(answers));
      });
    });

    on<UpdateAnswerEvent>((event, emit) async {
      emit(AnswerLoading());
      final result = await updateAnswerUsecase(
          UpdateAnswerParams(event.answerEntity, event.id));

      result.fold((l) {
        emit(AnswerError(l.message));
      }, (successMessage) {
        emit(AnswerUpdated(successMessage));
      });
    });

    on<DeleteAnswerEvent>((event, emit) async {
      emit(AnswerLoading());
      final result = await deleteAnswerUsecase(DeleteAnswerParams(event.id));

      result.fold((l) {
        emit(AnswerError(l.message));
      }, (successMessage) {
        emit(AnswerDeleted(successMessage));
      });
    });
  }
}
