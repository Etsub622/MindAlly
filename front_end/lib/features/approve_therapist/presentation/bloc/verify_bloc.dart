
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:front_end/core/error/failure.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/approve_therapist/domain/entity/therapist_verify_entity.dart';

import 'package:front_end/features/approve_therapist/domain/usecase/therapist_verify_usecase.dart';
import 'package:meta/meta.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final GetTherapistsToVerifyUsecase getTherapistsUsecase;
  final TherapistVerifyUsecase verifyUsecase;
  final RejectTherapistUsecase rejectUsecase;

  VerifyBloc({
    required this.getTherapistsUsecase,
    required this.verifyUsecase,
    required this.rejectUsecase,
  }) : super(VerifyInitial()) {
    on<LoadTherapistsEvent>(_onLoadTherapists);
    on<ApproveTherapistEvent>(_onApproveTherapist);
    on<RejectTherapistEvent>(_onRejectTherapist);
  }

  Future<void> _onLoadTherapists(LoadTherapistsEvent event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    final result = await getTherapistsUsecase(NoParams());
    emit(result.fold(
      (failure) => VerifyError(message: failure.message),
      (therapists) => VerifyLoaded(therapists: therapists),
    ));
  }

  Future<void> _onApproveTherapist(ApproveTherapistEvent event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    final result = await verifyUsecase(VerifyTherapistParams(id: event.id, ));
    emit(result.fold(
      (failure) => VerifyError(message: failure.message),
      (_) => VerifyActionSuccess(message: 'Therapist approved successfully'),
    ));
  }

  Future<void> _onRejectTherapist(RejectTherapistEvent event, Emitter<VerifyState> emit) async {
    emit(VerifyLoading());
    final result = await rejectUsecase(RejectTherapistParams(id: event.id, reason: event.reason));
    emit(result.fold(
      (failure) => VerifyError(message: failure.message),
      (_) => VerifyActionSuccess(message: 'Therapist rejected successfully'),
    ));
  }
}