import 'package:bloc/bloc.dart';
import 'package:front_end/core/usecase/usecase.dart';
import 'package:front_end/features/resource/domain/entity/video_entity.dart';
import 'package:front_end/features/resource/domain/usecase/video.dart';
import 'package:meta/meta.dart';

part 'video_event.dart';
part 'video_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final AddVideoUsecase addVideoUsecase;
  final GetVideosUSecase getVideosUsecase;
  final UpdateVideoUsecase updateVideoUsecase;
  final DeleteVideoUsecase deleteVideoUsecase;
  final SearchVideoUsecase searchVideoUsecase;
  VideoBloc(
    this.addVideoUsecase,
    this.deleteVideoUsecase,
    this.getVideosUsecase,
    this.searchVideoUsecase,
    this.updateVideoUsecase,
  ) : super(VideoInitial()) {
    on<AddVideoEvent>((event, emit) async {
      emit(VideoLoading());

      final book = await addVideoUsecase(AddVideoParams(event.videoEntity));

      book.fold((l) {
        emit(VideoError(l.message));
      }, (r) {
        emit(VideoAdded(r));
      });
    });

    on<GetVideoEvent>((event, emit) async {
      emit(VideoLoading());
      final video = await getVideosUsecase(NoParams());
      video.fold((l) {
        emit(VideoError(l.message));
      }, (videos) {
        emit(VideoLoaded(videos));
      });
    });


     on<UpdateVideoEvent>((event, emit) async {
      emit(VideoLoading());
      final result = await updateVideoUsecase(
          UPdateVideoParams(event.videoEntity, event.id));

      result.fold((l) {
        emit(VideoError(l.message));
      }, (successMessage) {
        emit(VideoUpdated(successMessage));
      });
    });


     on<DeleteVideoEvent>((event, emit) async {
      emit(VideoLoading());
      final result = await deleteVideoUsecase(DeleteVideoParams(event.id));

      result.fold((l) {
        emit(VideoError(l.message));
      }, (successMessage) {
        emit(VideoDeleted(successMessage));
      });
    });

    on<SearchVideoEvent>((event, emit) async {
      emit(VideoLoading());
      final result =
          await searchVideoUsecase(SearchVideoParams(event.title));

      result.fold((l) {
        emit(VideoError(l.message));
      }, (video) {
        emit(SearchVideoLoaded(video));
      });
    });
  }
}
