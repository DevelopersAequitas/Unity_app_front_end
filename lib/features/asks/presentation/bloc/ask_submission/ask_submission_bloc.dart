import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_and_publish_ask_usecase.dart';
import 'ask_submission_event.dart';
import 'ask_submission_state.dart';

class AskSubmissionBloc extends Bloc<AskSubmissionEvent, AskSubmissionState> {
  final CreateAndPublishAskUseCase createAndPublishAskUseCase;

  AskSubmissionBloc({required this.createAndPublishAskUseCase})
      : super(const AskSubmissionState()) {
    on<AskPublishRequested>(_onPublishRequested);
  }

  Future<void> _onPublishRequested(
    AskPublishRequested event,
    Emitter<AskSubmissionState> emit,
  ) async {
    emit(state.copyWith(status: AskSubmissionStatus.loading));
    try {
      final askId = await createAndPublishAskUseCase.execute(event.submission);
      emit(state.copyWith(
        status: AskSubmissionStatus.success,
        publishedAskId: askId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AskSubmissionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
