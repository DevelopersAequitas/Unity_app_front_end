import '../entities/geo_peer_entity.dart';
import '../repositories/peers_repository.dart';

class GetNearbyPeersUseCase {
  final PeersRepository repository;

  GetNearbyPeersUseCase(this.repository);

  Future<List<GeoPeerEntity>> call({
    int page = 1,
    int limit = 20,
    double? radiusKm,
    double? latitude,
    double? longitude,
  }) {
    return repository.getNearbyPeers(
      page: page,
      limit: limit,
      radiusKm: radiusKm,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
