import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/coin_guidelines_model.dart';
import '../models/impact_guidelines_model.dart';
import '../models/leaderboard_model.dart';

abstract class LeaderboardLocalDataSource {
  Future<void> cacheCoinsLeaderboard(dynamic rawData);
  Future<LeaderboardModel?> getCachedCoinsLeaderboard();
  Future<void> cacheImpactsLeaderboard(dynamic rawData);
  Future<LeaderboardModel?> getCachedImpactsLeaderboard();
  Future<void> cacheCoinGuidelines(dynamic rawData);
  Future<CoinGuidelinesModel?> getCachedCoinGuidelines();
  Future<void> cacheImpactGuidelines(dynamic rawData);
  Future<ImpactGuidelinesModel?> getCachedImpactGuidelines();
}

class LeaderboardLocalDataSourceImpl implements LeaderboardLocalDataSource {
  final CacheStore cacheStore;

  LeaderboardLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<void> cacheCoinsLeaderboard(dynamic rawData) async {
    await cacheStore.set(
      AppCacheBoxes.leaderboardBox,
      AppCacheKeys.coinsLeaderboard,
      rawData,
    );
  }

  @override
  Future<LeaderboardModel?> getCachedCoinsLeaderboard() async {
    try {
      final cached = await cacheStore.get<dynamic>(
        AppCacheBoxes.leaderboardBox,
        AppCacheKeys.coinsLeaderboard,
      );
      if (cached != null) {
        return LeaderboardModel.fromJson(cached);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> cacheImpactsLeaderboard(dynamic rawData) async {
    await cacheStore.set(
      AppCacheBoxes.leaderboardBox,
      AppCacheKeys.impactLeaderboard,
      rawData,
    );
  }

  @override
  Future<LeaderboardModel?> getCachedImpactsLeaderboard() async {
    try {
      final cached = await cacheStore.get<dynamic>(
        AppCacheBoxes.leaderboardBox,
        AppCacheKeys.impactLeaderboard,
      );
      if (cached != null) {
        return LeaderboardModel.fromJson(cached);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> cacheCoinGuidelines(dynamic rawData) async {
    await cacheStore.set(
      AppCacheBoxes.leaderboardBox,
      AppCacheKeys.coinGuidelines,
      rawData,
    );
  }

  @override
  Future<CoinGuidelinesModel?> getCachedCoinGuidelines() async {
    try {
      final cached = await cacheStore.get<dynamic>(
        AppCacheBoxes.leaderboardBox,
        AppCacheKeys.coinGuidelines,
      );
      if (cached != null) {
        return CoinGuidelinesModel.fromJson(cached);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> cacheImpactGuidelines(dynamic rawData) async {
    await cacheStore.set(
      AppCacheBoxes.leaderboardBox,
      AppCacheKeys.impactGuidelines,
      rawData,
    );
  }

  @override
  Future<ImpactGuidelinesModel?> getCachedImpactGuidelines() async {
    try {
      final cached = await cacheStore.get<dynamic>(
        AppCacheBoxes.leaderboardBox,
        AppCacheKeys.impactGuidelines,
      );
      if (cached != null) {
        return ImpactGuidelinesModel.fromJson(cached);
      }
    } catch (_) {}
    return null;
  }
}

