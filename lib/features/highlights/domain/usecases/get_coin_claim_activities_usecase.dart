import '../entities/claim_activity_entity.dart';
import '../repositories/coins_repository.dart';

class GetCoinClaimActivitiesUseCase {
  final CoinsRepository repository;
  const GetCoinClaimActivitiesUseCase(this.repository);

  Future<List<ClaimActivityEntity>> call() {
    return repository.getCoinClaimActivities();
  }
}
