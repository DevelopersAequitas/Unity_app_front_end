import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../domain/entities/peer_entity.dart';
import '../../domain/usecases/get_all_peers_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';
import '../../domain/usecases/toggle_peer_bookmark_usecase.dart';
import 'peers_event.dart';
import 'peers_state.dart';

class PeersBloc extends Bloc<PeersEvent, PeersState> {
  final GetAllPeersUseCase getAllPeersUseCase;
  final SendConnectionRequestUseCase sendConnectionRequestUseCase;
  final TogglePeerBookmarkUseCase togglePeerBookmarkUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  PeersBloc({
    required this.getAllPeersUseCase,
    required this.sendConnectionRequestUseCase,
    required this.togglePeerBookmarkUseCase,
  }) : super(const PeersState()) {
    on<PeersFetchRequested>(_onFetch);
    on<PeersRefreshRequested>(_onRefresh);
    on<PeersLoadMoreRequested>(_onLoadMore);
    on<PeersSearchChanged>(_onSearchChanged);
    on<PeersSortChanged>(_onSortChanged);
    on<PeerConnectRequested>(_onConnect);
    on<PeerBookmarkToggled>(_onBookmark);
    on<PeerStatusUpdated>(_onStatusUpdated);

    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (event is PeerConnectionAcceptedEvent) {
        add(PeerStatusUpdated(peerId: event.peerId, status: 'connected'));
      } else if (event is PeerConnectionRequestedEvent) {
        add(PeerStatusUpdated(peerId: event.peerId, status: 'pending'));
      } else if (event is PeerConnectionDeclinedEvent ||
          event is PeerConnectionCancelledEvent) {
        add(PeerStatusUpdated(
          peerId: event is PeerConnectionDeclinedEvent
              ? event.peerId
              : (event as PeerConnectionCancelledEvent).peerId,
          status: 'none',
        ));
      } else if (event is PeersSyncNeededEvent) {
        add(const PeersRefreshRequested());
      }
    });
  }

  List<PeerEntity> _applySort(List<PeerEntity> list, String sort) {
    final sorted = List<PeerEntity>.from(list);
    switch (sort) {
      case 'Alphabetical (A-Z)':
        sorted.sort((a, b) =>
            a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));
        break;
      case 'Alphabetical (Z-A)':
        sorted.sort((a, b) =>
            b.displayName.toLowerCase().compareTo(a.displayName.toLowerCase()));
        break;
      case 'Highest Impact':
        sorted.sort((a, b) =>
            (b.lifeImpactedCount ?? 0).compareTo(a.lifeImpactedCount ?? 0));
        break;
      case 'Most Recent':
      default:
        break;
    }
    return sorted;
  }

  bool _isNotConnected(PeerEntity p) {
    final status = p.connectionStatus.toLowerCase();
    return status != 'connected' &&
        status != 'approved' &&
        status != 'accepted' &&
        status != 'is_connected';
  }

  void _onStatusUpdated(
    PeerStatusUpdated event,
    Emitter<PeersState> emit,
  ) {
    final statusLower = event.status.toLowerCase();
    if (statusLower == 'connected' ||
        statusLower == 'approved' ||
        statusLower == 'accepted') {
      // Filter out connected peers from Peers Tab
      final updated = state.peers.where((p) => p.id != event.peerId).toList();
      emit(state.copyWith(peers: updated));
    } else {
      final updated = state.peers.map((p) {
        return p.id == event.peerId ? p.copyWith(connectionStatus: event.status) : p;
      }).toList();
      emit(state.copyWith(peers: updated));
    }
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }

  Future<void> _onFetch(
    PeersFetchRequested event,
    Emitter<PeersState> emit,
  ) async {
    if (state.peers.isEmpty) {
      emit(state.copyWith(status: PeersStatus.loading, page: 1));
    }
    try {
      final peers = await getAllPeersUseCase(
        page: 1,
        search: state.searchQuery,
        sort: state.selectedSort,
      );
      final nonConnectedPeers = peers.where(_isNotConnected).toList();
      final sortedPeers = _applySort(nonConnectedPeers, state.selectedSort);
      emit(state.copyWith(
        status: PeersStatus.success,
        peers: sortedPeers,
        hasMore: peers.length >= 20,
        page: 1,
      ));
    } catch (e) {
      if (state.peers.isEmpty) {
        emit(state.copyWith(
          status: PeersStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onRefresh(
    PeersRefreshRequested event,
    Emitter<PeersState> emit,
  ) async {
    try {
      final peers = await getAllPeersUseCase(
        page: 1,
        search: state.searchQuery,
        sort: state.selectedSort,
      );
      final nonConnectedPeers = peers.where(_isNotConnected).toList();
      final sortedPeers = _applySort(nonConnectedPeers, state.selectedSort);
      emit(state.copyWith(
        status: PeersStatus.success,
        peers: sortedPeers,
        hasMore: peers.length >= 20,
        page: 1,
      ));
    } catch (_) {}
  }

  Future<void> _onLoadMore(
    PeersLoadMoreRequested event,
    Emitter<PeersState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final newPeers = await getAllPeersUseCase(
        page: nextPage,
        search: state.searchQuery,
        sort: state.selectedSort,
      );
      if (newPeers.isEmpty) {
        emit(state.copyWith(
          hasMore: false,
          isLoadingMore: false,
        ));
        return;
      }
      final nonConnectedNewPeers = newPeers.where(_isNotConnected).toList();
      final existingIds = state.peers.map((p) => p.id).toSet();
      final uniqueNewPeers =
          nonConnectedNewPeers.where((p) => !existingIds.contains(p.id)).toList();
      final combined = [...state.peers, ...uniqueNewPeers];
      emit(state.copyWith(
        peers: _applySort(combined, state.selectedSort),
        page: nextPage,
        hasMore: newPeers.length >= 20,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSearchChanged(
    PeersSearchChanged event,
    Emitter<PeersState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query, page: 1));
    add(const PeersFetchRequested());
  }

  Future<void> _onSortChanged(
    PeersSortChanged event,
    Emitter<PeersState> emit,
  ) async {
    final sortedPeers = _applySort(state.peers, event.sort);
    emit(state.copyWith(selectedSort: event.sort, peers: sortedPeers));
  }

  Future<void> _onConnect(
    PeerConnectRequested event,
    Emitter<PeersState> emit,
  ) async {
    add(PeerStatusUpdated(peerId: event.peerId, status: 'pending'));
    PeersEventBus.instance.emit(
      PeerConnectionRequestedEvent(peerId: event.peerId),
    );
    try {
      await sendConnectionRequestUseCase(event.peerId);
    } catch (_) {}
  }

  Future<void> _onBookmark(
    PeerBookmarkToggled event,
    Emitter<PeersState> emit,
  ) async {
    final updated = state.peers.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isBookmarked: !event.isCurrentlyBookmarked);
      }
      return p;
    }).toList();
    emit(state.copyWith(peers: updated));
    try {
      await togglePeerBookmarkUseCase(
        event.peerId,
        event.isCurrentlyBookmarked,
      );
    } catch (_) {}
  }
}
