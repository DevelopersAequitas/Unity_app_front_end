import '../entities/network_stats_entity.dart';
import '../repositories/my_network_repository.dart';

class GenerateInviteCodeUseCase {
  final MyNetworkRepository repository;
  const GenerateInviteCodeUseCase(this.repository);

  Future<NetworkStatsEntity> call() => repository.generateInviteCode();
}
