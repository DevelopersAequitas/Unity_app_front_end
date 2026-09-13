import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/circle_category_model.dart';
import '../models/circle_model.dart';

abstract class CirclesLocalDataSource {
  Future<void> cacheMyCircles(List<CircleModel> circles);
  Future<List<CircleModel>> getCachedMyCircles();
  Future<void> cacheCircleCategories(List<CircleCategoryModel> categories);
  Future<List<CircleCategoryModel>> getCachedCircleCategories();
}

class CirclesLocalDataSourceImpl implements CirclesLocalDataSource {
  final CacheStore cacheStore;

  CirclesLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<void> cacheMyCircles(List<CircleModel> circles) async {
    final list = circles.map((c) => c.toJson()).toList();
    await cacheStore.set(AppCacheBoxes.circlesBox, AppCacheKeys.myCircles, list);
  }

  @override
  Future<List<CircleModel>> getCachedMyCircles() async {
    final list = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.circlesBox,
      AppCacheKeys.myCircles,
    );
    if (list == null) return const [];
    return list
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => CircleModel.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }

  @override
  Future<void> cacheCircleCategories(List<CircleCategoryModel> categories) async {
    final list = categories.map((c) => c.toJson()).toList();
    await cacheStore.set(
      AppCacheBoxes.circlesBox,
      AppCacheKeys.circleCategories,
      list,
    );
  }

  @override
  Future<List<CircleCategoryModel>> getCachedCircleCategories() async {
    final list = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.circlesBox,
      AppCacheKeys.circleCategories,
    );
    if (list == null) return const [];
    return list
        .whereType<Map<dynamic, dynamic>>()
        .map((m) => CircleCategoryModel.fromJson(Map<String, dynamic>.from(m)))
        .toList();
  }
}
