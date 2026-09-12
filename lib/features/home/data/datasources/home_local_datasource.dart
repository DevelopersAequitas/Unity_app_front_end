import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/brand_partner_model.dart';
import '../models/timeline_feed_response_model.dart';

abstract class HomeLocalDataSource {
  Future<void> cacheTimelineFeed(Map<String, dynamic> json);
  Future<TimelineFeedResponseModel?> getCachedTimelineFeed();
  Future<void> cacheBrandPartners(List<Map<String, dynamic>> jsonList);
  Future<List<BrandPartnerModel>> getCachedBrandPartners();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final CacheStore cacheStore;

  HomeLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<void> cacheTimelineFeed(Map<String, dynamic> json) async {
    await cacheStore.set(
      AppCacheBoxes.homeFeedBox,
      AppCacheKeys.timelineFeed,
      json,
    );
  }

  @override
  Future<TimelineFeedResponseModel?> getCachedTimelineFeed() async {
    final cached = await cacheStore.get<Map<String, dynamic>>(
      AppCacheBoxes.homeFeedBox,
      AppCacheKeys.timelineFeed,
    );
    if (cached != null) {
      try {
        return TimelineFeedResponseModel.fromJson(cached);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> cacheBrandPartners(List<Map<String, dynamic>> jsonList) async {
    await cacheStore.set(
      AppCacheBoxes.homeFeedBox,
      AppCacheKeys.brandPartners,
      jsonList,
    );
  }

  @override
  Future<List<BrandPartnerModel>> getCachedBrandPartners() async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.homeFeedBox,
      AppCacheKeys.brandPartners,
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => BrandPartnerModel.fromJson(e))
          .toList();
    }
    return [];
  }
}
