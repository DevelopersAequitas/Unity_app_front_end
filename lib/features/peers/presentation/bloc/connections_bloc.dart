import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../domain/usecases/follow_user_usecase.dart';
import '../../domain/usecases/unfollow_user_usecase.dart';
import '../../domain/usecases/get_my_connections_usecase.dart';
import '../../domain/usecases/toggle_peer_bookmark_usecase.dart';
import 'connections_event.dart';
import 'connections_state.dart';

class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  final GetMyConnectionsUseCase getMyConnectionsUseCase;
  final TogglePeerBookmarkUseCase togglePeerBookmarkUseCase;
  final FollowUserUseCase followUserUseCase;
  final UnfollowUserUseCase unfollowUserUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  ConnectionsBloc({
    required this.getMyConnectionsUseCase,
    required this.togglePeerBookmarkUseCase,
    required this.followUserUseCase,
    required this.unfollowUserUseCase,
  }) : super(const ConnectionsState()) {
    on<ConnectionsFetchRequested>(_onFetch);
    on<ConnectionsRefreshRequested>(_onRefresh);
    on<ConnectionsLoadMoreRequested>(_onLoadMore);
    on<ConnectionsSearchChanged>(_onSearchChanged);
    on<ConnectionBookmarkToggled>(_onBookmark);
    on<ConnectionFollowToggled>(_onFollow);
    on<ConnectionAdded>(_onConnectionAdded);
    on<ConnectionPeerFollowUpdated>(_onPeerFollowUpdated);
    on<ConnectionPeerBookmarkUpdated>(_onPeerBookmarkUpdated);

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
      } else if (event is PeerFollowToggledEvent) {
        add(ConnectionPeerFollowUpdated(
          peerId: event.peerId,
          isFollowing: event.isFollowing,
        ));
      } else if (event is PeerBookmarkToggledEvent) {
        add(ConnectionPeerBookmarkUpdated(
          peerId: event.peerId,
          isBookmarked: event.isBookmarked,
        ));
      }
    });
  }

  void _onPeerFollowUpdated(
    ConnectionPeerFollowUpdated event,
    Emitter<ConnectionsState> emit,
  ) {
    final updated = state.connections.map((p) {
      return p.id == event.peerId ? p.copyWith(isFollowing: event.isFollowing) : p;
    }).toList();
    emit(state.copyWith(connections: updated));
  }

  void _onPeerBookmarkUpdated(
    ConnectionPeerBookmarkUpdated event,
    Emitter<ConnectionsState> emit,
  ) {
    final updated = state.connections.map((p) {
      return p.id == event.peerId ? p.copyWith(isBookmarked: event.isBookmarked) : p;
    }).toList();
    emit(state.copyWith(connections: updated));
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
    final nextBookmark = !event.isCurrentlyBookmarked;
    final updated = state.connections.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isBookmarked: nextBookmark);
      }
      return p;
    }).toList();
    emit(state.copyWith(connections: updated));
    PeersEventBus.instance.emit(
      PeerBookmarkToggledEvent(peerId: event.peerId, isBookmarked: nextBookmark),
    );
    try {
      await togglePeerBookmarkUseCase(
        event.peerId,
        event.isCurrentlyBookmarked,
      );
    } catch (_) {}
  }

  Future<void> _onFollow(
    ConnectionFollowToggled event,
    Emitter<ConnectionsState> emit,
  ) async {
    final nextFollowing = !event.isCurrentlyFollowing;
    final updated = state.connections.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isFollowing: nextFollowing);
      }
      return p;
    }).toList();
    emit(state.copyWith(connections: updated));
    PeersEventBus.instance.emit(
      PeerFollowToggledEvent(peerId: event.peerId, isFollowing: nextFollowing),
    );

    try {
      if (event.isCurrentlyFollowing) {
        await unfollowUserUseCase(event.peerId);
      } else {
        await followUserUseCase(event.peerId);
      }
    } catch (_) {
      // Rollback on failure
      final rollback = state.connections.map((p) {
        if (p.id == event.peerId) {
          return p.copyWith(isFollowing: event.isCurrentlyFollowing);
        }
        return p;
      }).toList();
      emit(state.copyWith(connections: rollback));
      PeersEventBus.instance.emit(
        PeerFollowToggledEvent(peerId: event.peerId, isFollowing: event.isCurrentlyFollowing),
      );
    }
  }
}
