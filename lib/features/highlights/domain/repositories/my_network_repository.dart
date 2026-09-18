import '../entities/network_member_entity.dart';
import '../entities/network_stats_entity.dart';

abstract class MyNetworkRepository {
  Future<NetworkStatsEntity> getNetworkStats();
  Future<List<NetworkMemberEntity>> getNetworkMembers({int page = 1});
  Future<NetworkStatsEntity> generateInviteCode();
}
