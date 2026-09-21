import '../entities/business_deal_leaderboard_entity.dart';
import '../repositories/business_deals_repository.dart';

class GetBusinessDealsLeaderboardUseCase {
  final BusinessDealsRepository repository;

  GetBusinessDealsLeaderboardUseCase(this.repository);

  Future<List<BusinessDealLeaderboardEntity>> call() {
    return repository.getBusinessDealsLeaderboard();
  }
}
