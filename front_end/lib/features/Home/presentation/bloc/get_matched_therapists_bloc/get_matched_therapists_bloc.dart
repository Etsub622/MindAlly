
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_end/features/Home/domain/usecase/get_matched_therpaists_usecase.dart';
import 'package:front_end/features/profile_therapist/data/models/update_therapist_model.dart';

part 'get_matched_therapists_state.dart';
part 'get_matched_therapists_event.dart';


class GetMatchedTherapistsBloc extends Bloc<GetMatchedTherapistsEvent, GetMatchedTherapistsState> {
  final GetMatchedTherpaistsUseCase getMatchedTherpaistsUsecase;

  GetMatchedTherapistsBloc({required this.getMatchedTherpaistsUsecase}) : super(const GetMatchedTherapistsInitial()){
    on<GetMatchedTherapistsLoadEvent>((event, emit) async {
      emit(const GetMatchedTherapistsLoading());
    
    final result = await getMatchedTherpaistsUsecase(event.patientId);

    result.fold(
      (failure) => emit(GetMatchedTherapistsError(message: failure.message)),
      (therapists) {
        if(therapists.isEmpty){
          emit(const GetMatchedTherapistsEmpty());
        } else {
          emit(GetMatchedTherapistsLoaded(therapistList: therapists));
        }
      }
    );

    });

  }
}