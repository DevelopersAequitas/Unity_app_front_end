import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../domain/entities/peer_entity.dart';
import '../../domain/usecases/follow_user_usecase.dart';
import '../../domain/usecases/get_all_peers_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';
import '../../domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../domain/usecases/unfollow_user_usecase.dart';
import 'peers_event.dart';
import 'peers_state.dart';

class PeersBloc extends Bloc<PeersEvent, PeersState> {
  final GetAllPeersUseCase getAllPeersUseCase;
  final SendConnectionRequestUseCase sendConnectionRequestUseCase;
  final TogglePeerBookmarkUseCase togglePeerBookmarkUseCase;
  final FollowUserUseCase? followUserUseCase;
  final UnfollowUserUseCase? unfollowUserUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  PeersBloc({
    required this.getAllPeersUseCase,
    required this.sendConnectionRequestUseCase,
    required this.togglePeerBookmarkUseCase,
    this.followUserUseCase,
    this.unfollowUserUseCase,
  }) : super(const PeersState()) {
    on<PeersFetchRequested>(_onFetch);
    on<PeersRefreshRequested>(_onRefresh);
    on<PeersLoadMoreRequested>(_onLoadMore);
    on<PeersSearchChanged>(_onSearchChanged);
    on<PeersSortChanged>(_onSortChanged);
    on<PeerConnectRequested>(_onConnect);
    on<PeerBookmarkToggled>(_onBookmark);
    on<PeerFollowToggled>(_onFollowToggle);
    on<PeerStatusUpdated>(_onStatusUpdated);
    on<PeerFollowStatusSynced>((event, emit) {
      final updated = state.allPeers.map((p) {
        return p.id == event.peerId ? p.copyWith(isFollowing: event.isFollowing) : p;
      }).toList();
      emit(state.copyWith(allPeers: updated));
    });
    on<PeerBookmarkStatusSynced>((event, emit) {
      final updated = state.allPeers.map((p) {
        return p.id == event.peerId ? p.copyWith(isBookmarked: event.isBookmarked) : p;
      }).toList();
      emit(state.copyWith(allPeers: updated));
    });

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
      } else if (event is PeerFollowToggledEvent) {
        add(PeerFollowStatusSynced(peerId: event.peerId, isFollowing: event.isFollowing));
      } else if (event is PeerBookmarkToggledEvent) {
        add(PeerBookmarkStatusSynced(peerId: event.peerId, isBookmarked: event.isBookmarked));
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

  /// Excludes system/org accounts that have no company, designation, or category.
  bool _isRealPeer(PeerEntity p) {
    final hasCompany = p.companyName != null && p.companyName!.trim().isNotEmpty;
    final hasDesignation = p.designation != null && p.designation!.trim().isNotEmpty;
    final hasCategory = p.category != null && p.category!.trim().isNotEmpty;
    return hasCompany || hasDesignation || hasCategory;
  }

  void _onStatusUpdated(
    PeerStatusUpdated event,
    Emitter<PeersState> emit,
  ) {
    final updated = state.allPeers.map((p) {
      return p.id == event.peerId ? p.copyWith(connectionStatus: event.status) : p;
    }).toList();
    emit(state.copyWith(allPeers: updated));
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
    final isDefaultQuery = state.searchQuery.isEmpty;

    // 1. Instant Cache-first load if empty
    if (state.allPeers.isEmpty && isDefaultQuery) {
      final cached = await getAllPeersUseCase.getCached();
      if (cached.isNotEmpty) {
        final valid = cached.where((p) => _isRealPeer(p)).toList();
        final sorted = _applySort(valid, state.selectedSort);
        emit(state.copyWith(
          status: PeersStatus.success,
          allPeers: sorted,
          page: 1,
          hasMore: cached.length >= 20,
        ));
      } else {
        emit(state.copyWith(status: PeersStatus.loading, page: 1));
      }
    } else if (state.allPeers.isEmpty) {
      emit(state.copyWith(status: PeersStatus.loading, page: 1));
    }

    // 2. Background fresh remote fetch
    try {
      final peers = await getAllPeersUseCase(
        page: 1,
        search: state.searchQuery,
        sort: state.selectedSort,
      );
      final validPeers = peers.where((p) => _isRealPeer(p)).toList();
      final sortedPeers = _applySort(validPeers, state.selectedSort);
      emit(state.copyWith(
        status: PeersStatus.success,
        allPeers: sortedPeers,
        hasMore: peers.length >= 20,
        page: 1,
        errorMessage: null,
      ));
    } catch (e) {
      if (state.allPeers.isEmpty) {
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
      final validPeers2 = peers.where((p) => _isRealPeer(p)).toList();
      final sortedPeers = _applySort(validPeers2, state.selectedSort);
      emit(state.copyWith(
        status: PeersStatus.success,
        allPeers: sortedPeers,
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
      final validNewPeers = newPeers.where((p) => _isRealPeer(p)).toList();
      final existingIds = state.allPeers.map((p) => p.id).toSet();
      final uniqueNewPeers =
          validNewPeers.where((p) => !existingIds.contains(p.id)).toList();
      final combined = [...state.allPeers, ...uniqueNewPeers];
      emit(state.copyWith(
        allPeers: _applySort(combined, state.selectedSort),
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
    final sortedPeers = _applySort(state.allPeers, event.sort);
    emit(state.copyWith(selectedSort: event.sort, allPeers: sortedPeers));
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

  Future<void> _onFollowToggle(
    PeerFollowToggled event,
    Emitter<PeersState> emit,
  ) async {
    final nextFollowing = !event.isCurrentlyFollowing;
    final updated = state.allPeers.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isFollowing: nextFollowing);
      }
      return p;
    }).toList();
    emit(state.copyWith(allPeers: updated));
    PeersEventBus.instance.emit(
      PeerFollowToggledEvent(peerId: event.peerId, isFollowing: nextFollowing),
    );

    try {
      if (event.isCurrentlyFollowing) {
        await unfollowUserUseCase?.call(event.peerId);
      } else {
        await followUserUseCase?.call(event.peerId);
      }
    } catch (_) {
      final reverted = state.allPeers.map((p) {
        if (p.id == event.peerId) {
          return p.copyWith(isFollowing: event.isCurrentlyFollowing);
        }
        return p;
      }).toList();
      emit(state.copyWith(allPeers: reverted));
      PeersEventBus.instance.emit(
        PeerFollowToggledEvent(peerId: event.peerId, isFollowing: event.isCurrentlyFollowing),
      );
    }
  }

  Future<void> _onBookmark(
    PeerBookmarkToggled event,
    Emitter<PeersState> emit,
  ) async {
    final nextBookmark = !event.isCurrentlyBookmarked;
    final updated = state.allPeers.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isBookmarked: nextBookmark);
      }
      return p;
    }).toList();
    emit(state.copyWith(allPeers: updated));
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
}
