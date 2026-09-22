import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../domain/usecases/follow_user_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';
import '../../domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../domain/usecases/unfollow_user_usecase.dart';
import '../../domain/usecases/get_nearby_peers_usecase.dart';
import 'near_me_event.dart';
import 'near_me_state.dart';

class NearMeBloc extends Bloc<NearMeEvent, NearMeState> {
  final GetNearbyPeersUseCase getNearbyPeersUseCase;
  final FollowUserUseCase followUserUseCase;
  final UnfollowUserUseCase unfollowUserUseCase;
  final SendConnectionRequestUseCase? sendConnectionRequestUseCase;
  final TogglePeerBookmarkUseCase? togglePeerBookmarkUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  NearMeBloc({
    required this.getNearbyPeersUseCase,
    required this.followUserUseCase,
    required this.unfollowUserUseCase,
    this.sendConnectionRequestUseCase,
    this.togglePeerBookmarkUseCase,
  }) : super(const NearMeState()) {
    on<NearMeFetchRequested>(_onFetch);
    on<NearMeLoadMoreRequested>(_onLoadMore);
    on<NearMeRadiusChanged>(_onRadiusChanged);
    on<NearMeLocationUpdated>(_onLocationUpdated);
    on<NearMeFollowToggled>(_onFollow);
    on<NearMeConnectRequested>(_onConnect);
    on<NearMeBookmarkToggled>(_onBookmark);
    on<NearMeStatusUpdated>(_onStatusUpdated);
    on<NearMePeerFollowUpdated>(_onPeerFollowUpdated);
    on<NearMePeerBookmarkUpdated>(_onPeerBookmarkUpdated);

    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (event is PeerConnectionAcceptedEvent) {
        add(NearMeStatusUpdated(peerId: event.peerId, status: 'connected'));
      } else if (event is PeerConnectionRequestedEvent) {
        add(NearMeStatusUpdated(peerId: event.peerId, status: 'pending'));
      } else if (event is PeerConnectionDeclinedEvent ||
          event is PeerConnectionCancelledEvent) {
        add(NearMeStatusUpdated(
          peerId: event is PeerConnectionDeclinedEvent
              ? event.peerId
              : (event as PeerConnectionCancelledEvent).peerId,
          status: 'none',
        ));
      } else if (event is PeerFollowToggledEvent) {
        add(NearMePeerFollowUpdated(
          peerId: event.peerId,
          isFollowing: event.isFollowing,
        ));
      } else if (event is PeerBookmarkToggledEvent) {
        add(NearMePeerBookmarkUpdated(
          peerId: event.peerId,
          isBookmarked: event.isBookmarked,
        ));
      }
    });
  }

  void _onStatusUpdated(
    NearMeStatusUpdated event,
    Emitter<NearMeState> emit,
  ) {
    final updated = state.nearbyPeers.map((p) {
      return p.id == event.peerId ? p.copyWith(connectionStatus: event.status) : p;
    }).toList();
    emit(state.copyWith(nearbyPeers: updated));
  }

  void _onPeerFollowUpdated(
    NearMePeerFollowUpdated event,
    Emitter<NearMeState> emit,
  ) {
    final updated = state.nearbyPeers.map((p) {
      return p.id == event.peerId ? p.copyWith(isFollowing: event.isFollowing) : p;
    }).toList();
    emit(state.copyWith(nearbyPeers: updated));
  }

  void _onPeerBookmarkUpdated(
    NearMePeerBookmarkUpdated event,
    Emitter<NearMeState> emit,
  ) {
    final updated = state.nearbyPeers.map((p) {
      return p.id == event.peerId ? p.copyWith(isBookmarked: event.isBookmarked) : p;
    }).toList();
    emit(state.copyWith(nearbyPeers: updated));
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }

  Future<void> _onFetch(
    NearMeFetchRequested event,
    Emitter<NearMeState> emit,
  ) async {
    emit(state.copyWith(
      status: NearMeStatus.loading,
      page: 1,
      hasMore: true,
      isLoadingMore: false,
    ));
    try {
      double? lat = state.userLatitude;
      double? lng = state.userLongitude;

      if (lat == null || lng == null) {
        try {
          final serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (serviceEnabled) {
            var permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
            }
            if (permission == LocationPermission.whileInUse ||
                permission == LocationPermission.always) {
              final lastKnown = await Geolocator.getLastKnownPosition();
              if (lastKnown != null) {
                lat = lastKnown.latitude;
                lng = lastKnown.longitude;
              }
              final pos = await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.medium,
                  timeLimit: Duration(seconds: 3),
                ),
              );
              lat = pos.latitude;
              lng = pos.longitude;
            }
          }
        } catch (_) {
          // If GPS times out or is slow, continue gracefully to fetch API
        }
      }

      final peers = await getNearbyPeersUseCase(
        page: 1,
        limit: 20,
        radiusKm: state.selectedRadiusKm,
        latitude: lat,
        longitude: lng,
      );

      emit(state.copyWith(
        status: NearMeStatus.success,
        nearbyPeers: peers,
        page: 1,
        hasMore: peers.length >= 20,
        userLatitude: lat,
        userLongitude: lng,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NearMeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMore(
    NearMeLoadMoreRequested event,
    Emitter<NearMeState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore || state.status == NearMeStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final morePeers = await getNearbyPeersUseCase(
        page: nextPage,
        limit: 20,
        radiusKm: state.selectedRadiusKm,
        latitude: state.userLatitude,
        longitude: state.userLongitude,
      );

      final existingIds = state.nearbyPeers.map((p) => p.id).toSet();
      final newPeers = morePeers.where((p) => !existingIds.contains(p.id)).toList();
      final updatedList = [...state.nearbyPeers, ...newPeers];

      emit(state.copyWith(
        nearbyPeers: updatedList,
        page: nextPage,
        hasMore: morePeers.length >= 20,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRadiusChanged(
    NearMeRadiusChanged event,
    Emitter<NearMeState> emit,
  ) async {
    emit(state.copyWith(
      selectedRadiusKm: event.radiusKm,
      status: NearMeStatus.loading,
      page: 1,
      hasMore: true,
      isLoadingMore: false,
    ));
    try {
      final peers = await getNearbyPeersUseCase(
        page: 1,
        limit: 20,
        radiusKm: event.radiusKm,
        latitude: state.userLatitude,
        longitude: state.userLongitude,
      );
      emit(state.copyWith(
        status: NearMeStatus.success,
        nearbyPeers: peers,
        page: 1,
        hasMore: peers.length >= 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: NearMeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onLocationUpdated(
    NearMeLocationUpdated event,
    Emitter<NearMeState> emit,
  ) {
    emit(state.copyWith(
      userLatitude: event.latitude,
      userLongitude: event.longitude,
    ));
    add(const NearMeFetchRequested());
  }

  Future<void> _onFollow(
    NearMeFollowToggled event,
    Emitter<NearMeState> emit,
  ) async {
    final nextFollowing = !event.isCurrentlyFollowing;
    final updated = state.nearbyPeers.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isFollowing: nextFollowing);
      }
      return p;
    }).toList();
    emit(state.copyWith(nearbyPeers: updated));
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
      final rollback = state.nearbyPeers.map((p) {
        if (p.id == event.peerId) {
          return p.copyWith(isFollowing: event.isCurrentlyFollowing);
        }
        return p;
      }).toList();
      emit(state.copyWith(nearbyPeers: rollback));
      PeersEventBus.instance.emit(
        PeerFollowToggledEvent(peerId: event.peerId, isFollowing: event.isCurrentlyFollowing),
      );
    }
  }

  Future<void> _onConnect(
    NearMeConnectRequested event,
    Emitter<NearMeState> emit,
  ) async {
    add(NearMeStatusUpdated(peerId: event.peerId, status: 'pending'));
    PeersEventBus.instance.emit(
      PeerConnectionRequestedEvent(peerId: event.peerId),
    );
    try {
      await sendConnectionRequestUseCase?.call(event.peerId);
    } catch (_) {}
  }

  Future<void> _onBookmark(
    NearMeBookmarkToggled event,
    Emitter<NearMeState> emit,
  ) async {
    final nextBookmark = !event.isCurrentlyBookmarked;
    final updated = state.nearbyPeers.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isBookmarked: nextBookmark);
      }
      return p;
    }).toList();
    emit(state.copyWith(nearbyPeers: updated));
    PeersEventBus.instance.emit(
      PeerBookmarkToggledEvent(peerId: event.peerId, isBookmarked: nextBookmark),
    );
    try {
      await togglePeerBookmarkUseCase?.call(
        event.peerId,
        event.isCurrentlyBookmarked,
      );
    } catch (_) {}
  }
}

