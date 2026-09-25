import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../domain/usecases/get_match_peers_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';
import 'matches_event.dart';
import 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final GetMatchPeersUseCase getMatchPeersUseCase;
  final SendConnectionRequestUseCase sendConnectionRequestUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  MatchesBloc({
    required this.getMatchPeersUseCase,
    required this.sendConnectionRequestUseCase,
  }) : super(const MatchesState()) {
    on<MatchesFetchRequested>(_onFetch);
    on<MatchPassRequested>(_onPass);
    on<MatchConnectRequested>(_onConnect);
    on<MatchRemoved>(_onMatchRemoved);

    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (event is PeerConnectionRequestedEvent) {
        add(MatchRemoved(event.peerId));
      } else if (event is PeerConnectionAcceptedEvent) {
        add(MatchRemoved(event.peerId));
      }
    });
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }

  void _onMatchRemoved(
    MatchRemoved event,
    Emitter<MatchesState> emit,
  ) {
    final updated = state.matches.where((m) => m.id != event.peerId).toList();
    emit(state.copyWith(matches: updated));
  }

  Future<void> _onFetch(
    MatchesFetchRequested event,
    Emitter<MatchesState> emit,
  ) async {
    // 1. Instant Cache-first load if empty
    if (state.matches.isEmpty) {
      final cached = await getMatchPeersUseCase.getCached();
      if (cached.isNotEmpty) {
        emit(state.copyWith(
          status: MatchesStatus.success,
          matches: cached,
          currentIndex: 0,
        ));
      } else {
        emit(state.copyWith(status: MatchesStatus.loading, currentIndex: 0));
      }
    }

    // 2. Background fresh remote fetch
    try {
      final matches = await getMatchPeersUseCase();
      emit(state.copyWith(
        status: MatchesStatus.success,
        matches: matches,
        currentIndex: 0,
        errorMessage: null,
      ));
    } catch (e) {
      if (state.matches.isEmpty) {
        emit(state.copyWith(
          status: MatchesStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  void _onPass(
    MatchPassRequested event,
    Emitter<MatchesState> emit,
  ) {
    if (state.currentIndex < state.matches.length) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  Future<void> _onConnect(
    MatchConnectRequested event,
    Emitter<MatchesState> emit,
  ) async {
    final updated = state.matches.where((m) => m.id != event.peerId).toList();
    emit(state.copyWith(
      matches: updated,
      currentIndex: state.currentIndex < updated.length ? state.currentIndex : 0,
    ));

    PeersEventBus.instance.emit(
      PeerConnectionRequestedEvent(peerId: event.peerId),
    );
    try {
      await sendConnectionRequestUseCase(event.peerId);
    } catch (_) {}
  }
}
