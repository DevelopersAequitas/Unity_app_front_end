import 'dart:io';
import '../../domain/entities/business_deal_entity.dart';
import '../../domain/entities/business_deal_leaderboard_entity.dart';
import '../../domain/entities/create_business_deal_params.dart';
import '../../domain/entities/paginated_business_deals_entity.dart';
import '../../domain/repositories/business_deals_repository.dart';
import '../datasources/business_deals_remote_datasource.dart';

class BusinessDealsRepositoryImpl implements BusinessDealsRepository {
  final BusinessDealsRemoteDataSource remoteDataSource;

  BusinessDealsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<BusinessDealLeaderboardEntity>> getBusinessDealsLeaderboard() async {
    final models = await remoteDataSource.getBusinessDealsLeaderboard();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PaginatedBusinessDealsEntity> getUserBusinessDeals(
    String userId, {
    int page = 1,
    int perPage = 20,
  }) {
    return remoteDataSource.getUserBusinessDeals(
      userId,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<PaginatedBusinessDealsEntity> getReceivedBusinessDeals({
    int page = 1,
    int perPage = 20,
  }) {
    return remoteDataSource.getReceivedBusinessDeals(
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<PaginatedBusinessDealsEntity> getGivenBusinessDeals({
    int page = 1,
    int perPage = 20,
  }) {
    return remoteDataSource.getGivenBusinessDeals(
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<BusinessDealEntity> getBusinessDealDetail(String id) {
    return remoteDataSource.getBusinessDealDetail(id);
  }

  @override
  Future<BusinessDealEntity> createBusinessDeal(
      CreateBusinessDealParams params) {
    return remoteDataSource.createBusinessDeal(params);
  }

  @override
  Future<void> uploadActivityCreative({
    required String activityId,
    required String postId,
    required File creativeImage,
  }) {
    return remoteDataSource.uploadActivityCreative(
      activityId: activityId,
      postId: postId,
      creativeImage: creativeImage,
    );
  }
}
