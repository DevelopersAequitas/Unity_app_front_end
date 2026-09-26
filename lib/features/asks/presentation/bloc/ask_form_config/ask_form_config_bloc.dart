import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_ask_form_config_usecase.dart';
import 'ask_form_config_event.dart';
import 'ask_form_config_state.dart';

class AskFormConfigBloc extends Bloc<AskFormConfigEvent, AskFormConfigState> {
  final GetAskFormConfigUseCase getAskFormConfigUseCase;

  AskFormConfigBloc({required this.getAskFormConfigUseCase})
      : super(const AskFormConfigState()) {
    on<AskFormConfigFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
    AskFormConfigFetchRequested event,
    Emitter<AskFormConfigState> emit,
  ) async {
    emit(state.copyWith(status: AskFormConfigStatus.loading));
    try {
      final config = await getAskFormConfigUseCase(
        flowId: event.flowId,
        typeId: event.typeId,
      );
      emit(state.copyWith(
        status: AskFormConfigStatus.success,
        config: config,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AskFormConfigStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
