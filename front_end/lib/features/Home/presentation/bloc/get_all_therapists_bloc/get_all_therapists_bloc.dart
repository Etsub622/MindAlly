import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:front_end/features/Home/domain/usecase/get_all_therapists_usecase.dart';
import 'package:front_end/features/profile_therapist/data/models/therapist_model.dart';
import 'package:front_end/features/profile_therapist/domain/entities/update_therapist_entity.dart';

part 'get_all_therapists_event.dart';
part 'get_all_therapists_state.dart';

class GetAllTherapistsBloc extends Bloc<GetAllTherapistsEvent, GetAllTherapistsState> {
  final GetAllTherapistsUsecase getAllTherapistsUsecase;

  GetAllTherapistsBloc({required this.getAllTherapistsUsecase}) : super(GetAllTherapistsInitial()) {
    on<GetAllTherapistsLoadEvent>(_onLoadTherapists);
  }

  Future<void> _onLoadTherapists(GetAllTherapistsLoadEvent event, Emitter<GetAllTherapistsState> emit) async {
    emit(GetAllTherapistsLoading());

    final result = await getAllTherapistsUsecase();

    result.fold(
      (failure) => emit(GetAllTherapistsError(message: failure.message)),
      (therapists) {
        if (therapists.isEmpty) {
          emit(GetAllTherapistsEmpty());
        } else {
          emit(GetAllTherapistsLoaded(therapistList: therapists));
        }
      },
    );
  }
}