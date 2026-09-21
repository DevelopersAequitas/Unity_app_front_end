import '../../domain/entities/create_peer_referral_params.dart';
import '../../domain/entities/create_referral_params.dart';
import '../../domain/entities/paginated_referrals_entity.dart';
import '../../domain/entities/referral_entity.dart';
import '../../domain/entities/referral_leaderboard_entity.dart';
import '../../domain/entities/referral_stats_entity.dart';
import '../../domain/entities/referral_status_entity.dart';
import '../../domain/repositories/referrals_repository.dart';
import '../datasources/referrals_remote_datasource.dart';

class ReferralsRepositoryImpl implements ReferralsRepository {
  final ReferralsRemoteDataSource remoteDataSource;

  ReferralsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ReferralStatsEntity> getReferralsStats({int perPage = 15}) {
    return remoteDataSource.getReferralsStats(perPage: perPage);
  }

  @override
  Future<PaginatedReferralsEntity> getReceivedReferrals({
    int page = 1,
    int perPage = 15,
  }) {
    return remoteDataSource.getReceivedReferrals(page: page, perPage: perPage);
  }

  @override
  Future<PaginatedReferralsEntity> getGivenReferrals({
    int page = 1,
    int perPage = 15,
  }) {
    return remoteDataSource.getGivenReferrals(page: page, perPage: perPage);
  }

  @override
  Future<List<ReferralStatusEntity>> getReferralStatuses() {
    return remoteDataSource.getReferralStatuses();
  }

  @override
  Future<ReferralEntity> createReferral(CreateReferralParams params) {
    return remoteDataSource.createReferral(params);
  }

  @override
  Future<ReferralEntity> updateReferralStatus(String id, int statusId) {
    return remoteDataSource.updateReferralStatus(id, statusId);
  }

  @override
  Future<void> submitPeerReferral(CreatePeerReferralParams params) {
    return remoteDataSource.submitPeerReferral(params);
  }

  @override
  Future<ReferralEntity> getReferralDetail(String id) {
    return remoteDataSource.getReferralDetail(id);
  }

  @override
  Future<List<ReferralLeaderboardEntity>> getReferralsLeaderboard({int limit = 50}) async {
    final models = await remoteDataSource.getReferralsLeaderboard(limit: limit);
    return models.map((m) => m.toEntity()).toList();
  }
}

