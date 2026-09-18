import 'package:equatable/equatable.dart';
import '../../../domain/entities/network_member_entity.dart';
import '../../../domain/entities/network_stats_entity.dart';

enum MyNetworkStatus { initial, loading, success, failure }

class MyNetworkState extends Equatable {
  final MyNetworkStatus status;
  final NetworkStatsEntity stats;
  final List<NetworkMemberEntity> members;
  final String? errorMessage;

  const MyNetworkState({
    this.status = MyNetworkStatus.initial,
    this.stats = const NetworkStatsEntity(),
    this.members = const [],
    this.errorMessage,
  });

  MyNetworkState copyWith({
    MyNetworkStatus? status,
    NetworkStatsEntity? stats,
    List<NetworkMemberEntity>? members,
    String? errorMessage,
  }) {
    return MyNetworkState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      members: members ?? this.members,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, members, errorMessage];
}
