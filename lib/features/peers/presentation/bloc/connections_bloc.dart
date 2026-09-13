import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../domain/usecases/get_my_connections_usecase.dart';
import '../../domain/usecases/toggle_peer_bookmark_usecase.dart';
import 'connections_event.dart';
import 'connections_state.dart';

class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  final GetMyConnectionsUseCase getMyConnectionsUseCase;
  final TogglePeerBookmarkUseCase togglePeerBookmarkUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  ConnectionsBloc({
    required this.getMyConnectionsUseCase,
    required this.togglePeerBookmarkUseCase,
  }) : super(const ConnectionsState()) {
    on<ConnectionsFetchRequested>(_onFetch);
    on<ConnectionsRefreshRequested>(_onRefresh);
    on<ConnectionsLoadMoreRequested>(_onLoadMore);
    on<ConnectionsSearchChanged>(_onSearchChanged);
    on<ConnectionBookmarkToggled>(_onBookmark);
    on<ConnectionAdded>(_onConnectionAdded);

    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (event is PeerConnectionAcceptedEvent) {
        if (event.peer != null) {
          add(ConnectionAdded(event.peer!));
        }
        add(const ConnectionsRefreshRequested());
      } else if (event is PeerConnectionDeclinedEvent ||
          event is PeerConnectionCancelledEvent ||
          event is PeersSyncNeededEvent) {
        add(const ConnectionsRefreshRequested());
      }
    });
  }

  void _onConnectionAdded(
    ConnectionAdded event,
    Emitter<ConnectionsState> emit,
  ) {
    if (!state.connections.any((p) => p.id == event.peer.id)) {
      emit(state.copyWith(
        connections: [event.peer, ...state.connections],
      ));
    }
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }

  Future<void> _onFetch(
    ConnectionsFetchRequested event,
    Emitter<ConnectionsState> emit,
  ) async {
    final isDefaultQuery = state.searchQuery.isEmpty;

    // 1. Instant Cache-first load if empty
    if (state.connections.isEmpty && isDefaultQuery) {
      final cached = await getMyConnectionsUseCase.getCached();
      if (cached.isNotEmpty) {
        emit(state.copyWith(
          status: ConnectionsStatus.success,
          connections: cached,
          hasMore: cached.length >= 20,
          page: 1,
        ));
      } else {
        emit(state.copyWith(status: ConnectionsStatus.loading, page: 1));
      }
    } else if (state.connections.isEmpty) {
      emit(state.copyWith(status: ConnectionsStatus.loading, page: 1));
    }

    // 2. Background fresh remote fetch
    try {
      final connections = await getMyConnectionsUseCase(
        page: 1,
        search: state.searchQuery,
      );
      emit(state.copyWith(
        status: ConnectionsStatus.success,
        connections: connections,
        hasMore: connections.length >= 20,
        page: 1,
        errorMessage: null,
      ));
    } catch (e) {
      if (state.connections.isEmpty) {
        emit(state.copyWith(
          status: ConnectionsStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onRefresh(
    ConnectionsRefreshRequested event,
    Emitter<ConnectionsState> emit,
  ) async {
    try {
      final connections = await getMyConnectionsUseCase(
        page: 1,
        search: state.searchQuery,
      );
      emit(state.copyWith(
        status: ConnectionsStatus.success,
        connections: connections,
        hasMore: connections.length >= 20,
        page: 1,
      ));
    } catch (_) {}
  }

  Future<void> _onLoadMore(
    ConnectionsLoadMoreRequested event,
    Emitter<ConnectionsState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final newConnections = await getMyConnectionsUseCase(
        page: nextPage,
        search: state.searchQuery,
      );
      emit(state.copyWith(
        connections: [...state.connections, ...newConnections],
        page: nextPage,
        hasMore: newConnections.length >= 20,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSearchChanged(
    ConnectionsSearchChanged event,
    Emitter<ConnectionsState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    add(const ConnectionsFetchRequested());
  }

  Future<void> _onBookmark(
    ConnectionBookmarkToggled event,
    Emitter<ConnectionsState> emit,
  ) async {
    final updated = state.connections.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isBookmarked: !event.isCurrentlyBookmarked);
      }
      return p;
    }).toList();
    emit(state.copyWith(connections: updated));
    try {
      await togglePeerBookmarkUseCase(
        event.peerId,
        event.isCurrentlyBookmarked,
      );
    } catch (_) {}
  }
}
