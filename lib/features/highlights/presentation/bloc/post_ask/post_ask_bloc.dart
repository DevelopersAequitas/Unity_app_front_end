import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../profile/domain/usecases/upload_file_usecase.dart';
import '../../../domain/entities/post_ask_entity.dart';
import '../../../domain/usecases/complete_ask_usecase.dart';
import '../../../domain/usecases/get_my_asks_usecase.dart';
import '../../../domain/usecases/submit_post_ask_usecase.dart';
import 'post_ask_event.dart';
import 'post_ask_state.dart';

class PostAskBloc extends Bloc<PostAskEvent, PostAskState> {
  final GetMyAsksUseCase getMyAsksUseCase;
  final SubmitPostAskUseCase submitPostAskUseCase;
  final CompleteAskUseCase completeAskUseCase;
  final UploadProfileMediaUseCase? uploadProfileMediaUseCase;

  PostAskBloc({
    required this.getMyAsksUseCase,
    required this.submitPostAskUseCase,
    required this.completeAskUseCase,
    this.uploadProfileMediaUseCase,
  }) : super(const PostAskState()) {
    on<FetchMyAsksEvent>(_onFetchMyAsks);
    on<SubmitPostAskEvent>(_onSubmitPostAsk);
    on<CompleteAskEvent>(_onCompleteAsk);
    on<FilterAsksEvent>(_onFilterAsks);
  }

  Future<void> _onFetchMyAsks(
    FetchMyAsksEvent event,
    Emitter<PostAskState> emit,
  ) async {
    emit(state.copyWith(status: PostAskStatus.loading));
    try {
      final asks = await getMyAsksUseCase();
      emit(state.copyWith(
        status: PostAskStatus.initial,
        asks: asks,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PostAskStatus.error,
        errorMessage: 'Failed to load your asks: ${e.toString()}',
      ));
    }
  }

  Future<void> _onSubmitPostAsk(
    SubmitPostAskEvent event,
    Emitter<PostAskState> emit,
  ) async {
    emit(state.copyWith(status: PostAskStatus.submitting));
    try {
      String? mediaId = event.entity.mediaId;
      if (event.attachment != null && uploadProfileMediaUseCase != null) {
        emit(state.copyWith(isUploadingAttachment: true));
        final uploadResult = await uploadProfileMediaUseCase!(event.attachment!);
        mediaId = uploadResult;
        emit(state.copyWith(isUploadingAttachment: false));
      }

      final entityToSubmit = PostAskEntity(
        id: event.entity.id,
        subject: event.entity.subject,
        description: event.entity.description,
        category: event.entity.category,
        regionLabel: event.entity.regionLabel,
        cityName: event.entity.cityName,
        mediaId: mediaId,
        status: 'open',
      );

      final message = await submitPostAskUseCase(entityToSubmit);

      // Optimistically add to local list
      final updatedList = [
        PostAskEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          subject: entityToSubmit.subject,
          description: entityToSubmit.description,
          category: entityToSubmit.category,
          regionLabel: entityToSubmit.regionLabel,
          cityName: entityToSubmit.cityName,
          mediaId: mediaId,
          status: 'open',
          createdAt: DateTime.now(),
        ),
        ...state.asks,
      ];

      emit(state.copyWith(
        status: PostAskStatus.success,
        successMessage: message,
        asks: updatedList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PostAskStatus.error,
        errorMessage: 'Failed to submit ask: ${e.toString()}',
        isUploadingAttachment: false,
      ));
    }
  }

  Future<void> _onCompleteAsk(
    CompleteAskEvent event,
    Emitter<PostAskState> emit,
  ) async {
    try {
      await completeAskUseCase(event.id, subject: event.subject);
      final updated = state.asks.map((ask) {
        if (ask.id == event.id) {
          return PostAskEntity(
            id: ask.id,
            subject: ask.subject,
            description: ask.description,
            category: ask.category,
            regionLabel: ask.regionLabel,
            cityName: ask.cityName,
            mediaId: ask.mediaId,
            mediaUrl: ask.mediaUrl,
            status: 'completed',
            createdAt: ask.createdAt,
            authorName: ask.authorName,
            authorAvatar: ask.authorAvatar,
          );
        }
        return ask;
      }).toList();

      emit(state.copyWith(
        asks: updated,
        successMessage: 'Ask marked as completed!',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PostAskStatus.error,
        errorMessage: 'Failed to update ask: ${e.toString()}',
      ));
    }
  }

  void _onFilterAsks(
    FilterAsksEvent event,
    Emitter<PostAskState> emit,
  ) {
    emit(state.copyWith(activeFilter: event.filter));
  }
}
