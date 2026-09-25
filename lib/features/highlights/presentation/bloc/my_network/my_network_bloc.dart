import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/events/peers_event_bus.dart';
import 'package:unity_app/features/highlights/domain/entities/network_member_entity.dart';
import 'package:unity_app/features/highlights/domain/entities/network_stats_entity.dart';
import '../../../domain/repositories/my_network_repository.dart';
import '../../../domain/usecases/generate_invite_code_usecase.dart';
import '../../../domain/usecases/get_network_members_usecase.dart';
import '../../../domain/usecases/get_network_stats_usecase.dart';
import 'my_network_event.dart';
import 'my_network_state.dart';

class MyNetworkBloc extends Bloc<MyNetworkEvent, MyNetworkState> {
  final GetNetworkStatsUseCase getNetworkStatsUseCase;
  final GetNetworkMembersUseCase getNetworkMembersUseCase;
  final GenerateInviteCodeUseCase generateInviteCodeUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  MyNetworkBloc({
    required this.getNetworkStatsUseCase,
    required this.getNetworkMembersUseCase,
    required this.generateInviteCodeUseCase,
  }) : super(const MyNetworkState()) {
    on<FetchMyNetworkDataEvent>(_onFetchData);
    on<GenerateInviteCodeEvent>(_onGenerateCode);
    on<MyNetworkFollowStatusSynced>(_onFollowSynced);
    on<MyNetworkBookmarkStatusSynced>(_onBookmarkSynced);
    on<MyNetworkConnectionStatusSynced>(_onConnectionSynced);

    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (event is PeerFollowToggledEvent) {
        add(MyNetworkFollowStatusSynced(
          peerId: event.peerId,
          isFollowing: event.isFollowing,
        ));
      } else if (event is PeerBookmarkToggledEvent) {
        add(MyNetworkBookmarkStatusSynced(
          peerId: event.peerId,
          isBookmarked: event.isBookmarked,
        ));
      } else if (event is PeerConnectionRequestedEvent) {
        add(MyNetworkConnectionStatusSynced(
          peerId: event.peerId,
          connectionStatus: 'pending',
          isConnected: false,
        ));
      } else if (event is PeerConnectionAcceptedEvent) {
        add(MyNetworkConnectionStatusSynced(
          peerId: event.peerId,
          connectionStatus: 'connected',
          isConnected: true,
        ));
      } else if (event is PeerConnectionDeclinedEvent ||
          event is PeerConnectionCancelledEvent) {
        final peerId = event is PeerConnectionDeclinedEvent
            ? event.peerId
            : (event as PeerConnectionCancelledEvent).peerId;
        add(MyNetworkConnectionStatusSynced(
          peerId: peerId,
          connectionStatus: 'none',
          isConnected: false,
        ));
      } else if (event is PeersSyncNeededEvent) {
        add(const FetchMyNetworkDataEvent(isRefresh: true));
      }
    });
  }

  void _onFollowSynced(
    MyNetworkFollowStatusSynced event,
    Emitter<MyNetworkState> emit,
  ) {
    final updated = state.members.map((m) {
      if (m.id == event.peerId) {
        return m.copyWith(isFollowing: event.isFollowing);
      }
      return m;
    }).toList();
    emit(state.copyWith(members: updated));
  }

  void _onBookmarkSynced(
    MyNetworkBookmarkStatusSynced event,
    Emitter<MyNetworkState> emit,
  ) {
    final updated = state.members.map((m) {
      if (m.id == event.peerId) {
        return m.copyWith(isBookmarked: event.isBookmarked);
      }
      return m;
    }).toList();
    emit(state.copyWith(members: updated));
  }

  void _onConnectionSynced(
    MyNetworkConnectionStatusSynced event,
    Emitter<MyNetworkState> emit,
  ) {
    final updated = state.members.map((m) {
      if (m.id == event.peerId) {
        return m.copyWith(
          connectionStatus: event.connectionStatus,
          isConnected: event.isConnected,
        );
      }
      return m;
    }).toList();
    emit(state.copyWith(members: updated));
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }

  Future<void> _onFetchData(
    FetchMyNetworkDataEvent event,
    Emitter<MyNetworkState> emit,
  ) async {
    if (!event.isRefresh && state.status == MyNetworkStatus.initial) {
      emit(state.copyWith(status: MyNetworkStatus.loading));
    }
    try {
      final statsFuture = getNetworkStatsUseCase();
      final membersFuture = getNetworkMembersUseCase();
      final results = await Future.wait([statsFuture, membersFuture]);
      final stats = results[0] as NetworkStatsEntity;
      final membersResult = results[1] as NetworkMembersPageResult;
      final members = membersResult.members;

      int calculatedCoins = stats.rewardsEarned;
      if (calculatedCoins == 0) {
        calculatedCoins = members.fold<int>(
          0,
          (int sum, NetworkMemberEntity m) => sum + m.coinsEarned,
        );
      }
      final totalJoined = membersResult.total;

      final updatedStats = stats.copyWith(
        totalInvited: totalJoined,
        rewardsEarned: calculatedCoins,
      );

      emit(state.copyWith(
        status: MyNetworkStatus.success,
        stats: updatedStats,
        members: members,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MyNetworkStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onGenerateCode(
    GenerateInviteCodeEvent event,
    Emitter<MyNetworkState> emit,
  ) async {
    try {
      final updatedStats = await generateInviteCodeUseCase();
      emit(state.copyWith(stats: updatedStats));
    } catch (_) {}
  }
}
