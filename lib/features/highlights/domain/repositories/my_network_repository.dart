import '../entities/network_member_entity.dart';
import '../entities/network_stats_entity.dart';

/// Domain result for members — carries the real total from pagination.
class NetworkMembersPageResult {
  final List<NetworkMemberEntity> members;
  final int total;

  const NetworkMembersPageResult({required this.members, required this.total});
}

abstract class MyNetworkRepository {
  Future<NetworkStatsEntity> getNetworkStats();
  Future<NetworkMembersPageResult> getNetworkMembers({int page = 1});
  Future<NetworkStatsEntity> generateInviteCode();
}
