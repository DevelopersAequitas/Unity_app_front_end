import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/events/peers_event_bus.dart';
import '../../../domain/usecases/get_my_introduced_peers_usecase.dart';
import '../../../domain/usecases/get_top_builders_usecase.dart';
import 'top_builders_event.dart';
import 'top_builders_state.dart';

class TopBuildersBloc extends Bloc<TopBuildersEvent, TopBuildersState> {
  final GetTopBuildersUseCase getTopBuildersUseCase;
  final GetMyIntroducedPeersUseCase getMyIntroducedPeersUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  TopBuildersBloc({
    required this.getTopBuildersUseCase,
    required this.getMyIntroducedPeersUseCase,
  }) : super(const TopBuildersState()) {
    on<FetchTopBuildersDataEvent>(_onFetchData);
    on<SearchIntroducedPeersEvent>(_onSearch);
    on<TopBuildersFollowStatusSynced>(_onFollowSynced);
    on<TopBuildersBookmarkStatusSynced>(_onBookmarkSynced);
    on<TopBuildersConnectionStatusSynced>(_onConnectionSynced);

    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (event is PeerFollowToggledEvent) {
        add(TopBuildersFollowStatusSynced(
          peerId: event.peerId,
          isFollowing: event.isFollowing,
        ));
      } else if (event is PeerBookmarkToggledEvent) {
        add(TopBuildersBookmarkStatusSynced(
          peerId: event.peerId,
          isBookmarked: event.isBookmarked,
        ));
      } else if (event is PeerConnectionRequestedEvent) {
        add(TopBuildersConnectionStatusSynced(
          peerId: event.peerId,
          connectionStatus: 'pending',
          isConnected: false,
        ));
      } else if (event is PeerConnectionAcceptedEvent) {
        add(TopBuildersConnectionStatusSynced(
          peerId: event.peerId,
          connectionStatus: 'connected',
          isConnected: true,
        ));
      } else if (event is PeerConnectionDeclinedEvent ||
          event is PeerConnectionCancelledEvent) {
        final peerId = event is PeerConnectionDeclinedEvent
            ? event.peerId
            : (event as PeerConnectionCancelledEvent).peerId;
        add(TopBuildersConnectionStatusSynced(
          peerId: peerId,
          connectionStatus: 'none',
          isConnected: false,
        ));
      } else if (event is PeersSyncNeededEvent) {
        add(const FetchTopBuildersDataEvent(isRefresh: true));
      }
    });
  }

  void _onFollowSynced(
    TopBuildersFollowStatusSynced event,
    Emitter<TopBuildersState> emit,
  ) {
    final updatedBuilders = state.topBuilders.map((b) {
      if (b.id == event.peerId) {
        return b.copyWith(isFollowing: event.isFollowing);
      }
      return b;
    }).toList();
    final updatedIntroduced = state.myIntroduced.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isFollowing: event.isFollowing);
      }
      return p;
    }).toList();
    emit(state.copyWith(
      topBuilders: updatedBuilders,
      myIntroduced: updatedIntroduced,
    ));
  }

  void _onBookmarkSynced(
    TopBuildersBookmarkStatusSynced event,
    Emitter<TopBuildersState> emit,
  ) {
    final updatedBuilders = state.topBuilders.map((b) {
      if (b.id == event.peerId) {
        return b.copyWith(isBookmarked: event.isBookmarked);
      }
      return b;
    }).toList();
    final updatedIntroduced = state.myIntroduced.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(isBookmarked: event.isBookmarked);
      }
      return p;
    }).toList();
    emit(state.copyWith(
      topBuilders: updatedBuilders,
      myIntroduced: updatedIntroduced,
    ));
  }

  void _onConnectionSynced(
    TopBuildersConnectionStatusSynced event,
    Emitter<TopBuildersState> emit,
  ) {
    final updatedBuilders = state.topBuilders.map((b) {
      if (b.id == event.peerId) {
        return b.copyWith(
          connectionStatus: event.connectionStatus,
          isConnected: event.isConnected,
          isRequested: event.connectionStatus == 'pending',
        );
      }
      return b;
    }).toList();
    final updatedIntroduced = state.myIntroduced.map((p) {
      if (p.id == event.peerId) {
        return p.copyWith(
          connectionStatus: event.connectionStatus,
          isConnected: event.isConnected,
        );
      }
      return p;
    }).toList();
    emit(state.copyWith(
      topBuilders: updatedBuilders,
      myIntroduced: updatedIntroduced,
    ));
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }

  Future<void> _onFetchData(
    FetchTopBuildersDataEvent event,
    Emitter<TopBuildersState> emit,
  ) async {
    if (!event.isRefresh && state.status == TopBuildersStatus.initial) {
      emit(state.copyWith(status: TopBuildersStatus.loading));
    }
    try {
      final buildersFuture = getTopBuildersUseCase();
      final introducedFuture = getMyIntroducedPeersUseCase();
      final results = await Future.wait([buildersFuture, introducedFuture]);

      emit(state.copyWith(
        status: TopBuildersStatus.success,
        topBuilders: results[0] as dynamic,
        myIntroduced: results[1] as dynamic,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TopBuildersStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSearch(
    SearchIntroducedPeersEvent event,
    Emitter<TopBuildersState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
