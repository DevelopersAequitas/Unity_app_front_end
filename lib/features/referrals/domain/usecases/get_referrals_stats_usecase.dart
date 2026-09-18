import '../entities/referral_stats_entity.dart';
import '../repositories/referrals_repository.dart';

class GetReferralsStatsUseCase {
  final ReferralsRepository repository;

  GetReferralsStatsUseCase(this.repository);

  Future<ReferralStatsEntity> call({int perPage = 15}) {
    return repository.getReferralsStats(perPage: perPage);
  }
}
