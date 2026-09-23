import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/intro_video_model.dart';

abstract class ShortsLocalDataSource {
  Future<void> cacheShorts(List<Map<String, dynamic>> list);
  Future<List<IntroVideoModel>> getCachedShorts();
}

class ShortsLocalDataSourceImpl implements ShortsLocalDataSource {
  final CacheStore cacheStore;

  ShortsLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<void> cacheShorts(List<Map<String, dynamic>> list) async {
    await cacheStore.set(
      AppCacheBoxes.shortsBox,
      AppCacheKeys.shortsVideos,
      list,
    );
  }

  @override
  Future<List<IntroVideoModel>> getCachedShorts() async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.shortsBox,
      AppCacheKeys.shortsVideos,
    );
    if (cached != null) {
      try {
        return cached
            .whereType<Map<dynamic, dynamic>>()
            .map((item) => IntroVideoModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      } catch (_) {
        return [];
      }
    }
    return [];
  }
}
