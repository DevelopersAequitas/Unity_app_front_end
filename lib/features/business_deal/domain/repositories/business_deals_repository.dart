import 'dart:io';
import '../entities/business_deal_entity.dart';
import '../entities/business_deal_leaderboard_entity.dart';
import '../entities/create_business_deal_params.dart';
import '../entities/paginated_business_deals_entity.dart';

abstract class BusinessDealsRepository {
  Future<PaginatedBusinessDealsEntity> getUserBusinessDeals(
    String userId, {
    int page = 1,
    int perPage = 20,
  });

  Future<PaginatedBusinessDealsEntity> getReceivedBusinessDeals({
    int page = 1,
    int perPage = 20,
  });

  Future<PaginatedBusinessDealsEntity> getGivenBusinessDeals({
    int page = 1,
    int perPage = 20,
  });

  Future<List<BusinessDealLeaderboardEntity>> getBusinessDealsLeaderboard();

  Future<BusinessDealEntity> getBusinessDealDetail(String id);

  Future<BusinessDealEntity> createBusinessDeal(CreateBusinessDealParams params);

  Future<void> uploadActivityCreative({
    required String activityId,
    required String postId,
    required File creativeImage,
  });
}


