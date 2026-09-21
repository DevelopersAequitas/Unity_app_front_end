import '../entities/referral_leaderboard_entity.dart';
import '../repositories/referrals_repository.dart';

class GetReferralsLeaderboardUseCase {
  final ReferralsRepository repository;
  const GetReferralsLeaderboardUseCase(this.repository);

  Future<List<ReferralLeaderboardEntity>> call({int limit = 50}) =>
      repository.getReferralsLeaderboard(limit: limit);
}
