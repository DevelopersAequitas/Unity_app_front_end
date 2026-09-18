import '../entities/network_stats_entity.dart';
import '../repositories/my_network_repository.dart';

class GetNetworkStatsUseCase {
  final MyNetworkRepository repository;
  const GetNetworkStatsUseCase(this.repository);

  Future<NetworkStatsEntity> call() => repository.getNetworkStats();
}
