import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/congratulate_ask_usecase.dart';
import '../../../domain/usecases/get_peers_feed_usecase.dart';
import '../../../domain/usecases/toggle_save_ask_usecase.dart';
import 'peers_feed_event.dart';
import 'peers_feed_state.dart';

class PeersFeedBloc extends Bloc<PeersFeedEvent, PeersFeedState> {
  final GetPeersFeedUseCase getPeersFeedUseCase;
  final CongratulateAskUseCase? congratulateAskUseCase;
  final ToggleSaveAskUseCase? toggleSaveAskUseCase;

  PeersFeedBloc({
    required this.getPeersFeedUseCase,
    this.congratulateAskUseCase,
    this.toggleSaveAskUseCase,
  }) : super(const PeersFeedState()) {
    on<PeersFeedFetchRequested>(_onFetchRequested);
    on<PeersFeedCongratulateRequested>(_onCongratulateRequested);
    on<PeersFeedToggleSaveRequested>(_onToggleSaveRequested);
  }

  Future<void> _onFetchRequested(
    PeersFeedFetchRequested event,
    Emitter<PeersFeedState> emit,
  ) async {
    final scope = event.scope ?? state.selectedScope;
    if (!event.isRefresh) {
      emit(state.copyWith(status: PeersFeedStatus.loading, selectedScope: scope));
    }

    try {
      final items = await getPeersFeedUseCase(scope: scope);
      emit(state.copyWith(
        status: PeersFeedStatus.success,
        items: items,
        selectedScope: scope,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PeersFeedStatus.error,
        errorMessage: 'Unable to load Peers feed. Please try again.',
      ));
    }
  }

  Future<void> _onCongratulateRequested(
    PeersFeedCongratulateRequested event,
    Emitter<PeersFeedState> emit,
  ) async {
    final newSet = Set<String>.from(state.congratulatedIds)..add(event.askId);
    emit(state.copyWith(congratulatedIds: newSet));

    try {
      if (congratulateAskUseCase != null) {
        await congratulateAskUseCase!(event.askId, comment: event.comment);
      }
    } catch (_) {}
  }

  Future<void> _onToggleSaveRequested(
    PeersFeedToggleSaveRequested event,
    Emitter<PeersFeedState> emit,
  ) async {
    final newSet = Set<String>.from(state.savedIds);
    if (newSet.contains(event.askId)) {
      newSet.remove(event.askId);
    } else {
      newSet.add(event.askId);
    }
    emit(state.copyWith(savedIds: newSet));

    try {
      if (toggleSaveAskUseCase != null) {
        await toggleSaveAskUseCase!(event.askId);
      }
    } catch (_) {}
  }
}
