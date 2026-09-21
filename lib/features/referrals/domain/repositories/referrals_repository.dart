import '../entities/create_peer_referral_params.dart';
import '../entities/create_referral_params.dart';
import '../entities/paginated_referrals_entity.dart';
import '../entities/referral_entity.dart';
import '../entities/referral_leaderboard_entity.dart';
import '../entities/referral_stats_entity.dart';
import '../entities/referral_status_entity.dart';

abstract class ReferralsRepository {
  Future<ReferralStatsEntity> getReferralsStats({int perPage = 15});

  Future<PaginatedReferralsEntity> getReceivedReferrals({
    int page = 1,
    int perPage = 15,
  });

  Future<PaginatedReferralsEntity> getGivenReferrals({
    int page = 1,
    int perPage = 15,
  });

  Future<List<ReferralStatusEntity>> getReferralStatuses();

  Future<ReferralEntity> createReferral(CreateReferralParams params);

  Future<ReferralEntity> updateReferralStatus(String id, int statusId);

  Future<void> submitPeerReferral(CreatePeerReferralParams params);

  Future<ReferralEntity> getReferralDetail(String id);

  Future<List<ReferralLeaderboardEntity>> getReferralsLeaderboard({int limit = 50});
}

