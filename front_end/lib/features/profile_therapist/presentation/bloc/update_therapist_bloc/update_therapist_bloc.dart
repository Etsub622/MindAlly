import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';
import 'package:front_end/features/profile_therapist/domain/usecases/update_therapist_usecase.dart';


part 'update_therapist_event.dart';
part 'update_therapist_state.dart';





class UpdateTherapistBloc extends Bloc<UpdateTherapistEvent, UpdateTherapistState> {
  final UpdateTherapistUsecase updateTherapistUsecase;

  UpdateTherapistBloc({required this.updateTherapistUsecase}) : super(const UpdateTherapistInitial()) {
    on<UpdateTherapistLoadEvent>(_updateTherapist);
  }

  void _updateTherapist(UpdateTherapistLoadEvent event, Emitter<UpdateTherapistState> emit) async {
    emit(const UpdateTherapistLoading());

    final therapist = await updateTherapistUsecase(event.therapist);
    
    therapist.fold(
      (failure) => emit(UpdateTherapistError(message: failure.message)),
      (therapist) => emit(UpdateTherapistLoaded(therapist: therapist)),
    );
  }
}