import '../../domain/entities/network_member_entity.dart';
import '../../domain/entities/network_stats_entity.dart';
import '../../domain/repositories/my_network_repository.dart';
import '../datasources/my_network_remote_datasource.dart';

class MyNetworkRepositoryImpl implements MyNetworkRepository {
  final MyNetworkRemoteDataSource remoteDataSource;

  const MyNetworkRepositoryImpl({required this.remoteDataSource});

  @override
  Future<NetworkStatsEntity> getNetworkStats() async {
    final model = await remoteDataSource.getNetworkStats();
    return model.toEntity();
  }

  @override
  Future<List<NetworkMemberEntity>> getNetworkMembers({int page = 1}) async {
    final models = await remoteDataSource.getNetworkMembers(page: page);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<NetworkStatsEntity> generateInviteCode() async {
    final model = await remoteDataSource.generateInviteCode();
    return model.toEntity();
  }
}
