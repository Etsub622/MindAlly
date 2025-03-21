import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/profile_therapist/domain/usecases/delete_therapist_usecase.dart';


part 'delete_therapist_event.dart';
part 'delete_therapist_state.dart';





class DeleteTherapistBloc extends Bloc<DeleteTherapistEvent, DeleteTherapistState> {
  final DeleteTherapistUsecase deleteTherapistUsecase;

  DeleteTherapistBloc({required this.deleteTherapistUsecase}) : super(const DeleteTherapistInitial()) {
    on<DeleteTherapistLoadEvent>(_DeleteTherapist);
  }

  void _DeleteTherapist(DeleteTherapistLoadEvent event, Emitter<DeleteTherapistState> emit) async {
    emit(const DeleteTherapistLoading());

    final therapist = await deleteTherapistUsecase(event.therapistId);
    
    therapist.fold(
      (failure) => emit(DeleteTherapistError(message: failure.message)),
      (therapist) => emit(const DeleteTherapistLoaded()),
    );
  }
}