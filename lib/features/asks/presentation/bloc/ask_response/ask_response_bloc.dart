import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/submit_ask_response_usecase.dart';
import 'ask_response_event.dart';
import 'ask_response_state.dart';

class AskResponseBloc extends Bloc<AskResponseEvent, AskResponseState> {
  final SubmitAskResponseUseCase submitAskResponseUseCase;

  AskResponseBloc({required this.submitAskResponseUseCase})
      : super(const AskResponseState()) {
    on<AskResponseSubmitRequested>(_onSubmitRequested);
  }

  Future<void> _onSubmitRequested(
    AskResponseSubmitRequested event,
    Emitter<AskResponseState> emit,
  ) async {
    emit(state.copyWith(status: AskResponseStatus.loading));
    try {
      final success = await submitAskResponseUseCase.execute(
        askId: event.askId,
        responseType: event.responseType,
        message: event.message,
        timeline: event.timeline,
        extraData: event.extraData,
      );
      if (success) {
        emit(state.copyWith(status: AskResponseStatus.success));
      } else {
        emit(state.copyWith(
          status: AskResponseStatus.error,
          errorMessage: 'Failed to submit response.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AskResponseStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
