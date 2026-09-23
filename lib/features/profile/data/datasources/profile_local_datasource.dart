import 'dart:convert';
import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../../../home/data/models/timeline_item_model.dart';
import '../../../home/domain/entities/timeline_item_entity.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<void> clearCachedProfile();

  Future<void> cacheUserPosts(List<Map<String, dynamic>> posts);
  Future<List<TimelineItemEntity>> getCachedUserPosts();

  Future<void> cacheSavedPosts(List<Map<String, dynamic>> posts);
  Future<List<TimelineItemEntity>> getCachedSavedPosts();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final CacheStore cacheStore;

  ProfileLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<ProfileModel?> getCachedProfile() async {
    try {
      final raw = await cacheStore.get<String>(
        AppCacheBoxes.authBox,
        AppCacheKeys.userProfile,
      );
      if (raw != null && raw.isNotEmpty) {
        final map = jsonDecode(raw);
        if (map is Map<String, dynamic>) {
          return ProfileModel.fromJson(map);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    try {
      await cacheStore.set(
        AppCacheBoxes.authBox,
        AppCacheKeys.userProfile,
        jsonEncode(profile.toJson()),
      );
    } catch (_) {}
  }

  @override
  Future<void> clearCachedProfile() async {
    try {
      await cacheStore.delete(
        AppCacheBoxes.authBox,
        AppCacheKeys.userProfile,
      );
      await cacheStore.delete(
        AppCacheBoxes.profileBox,
        AppCacheKeys.userPosts,
      );
      await cacheStore.delete(
        AppCacheBoxes.profileBox,
        AppCacheKeys.savedPosts,
      );
    } catch (_) {}
  }

  @override
  Future<void> cacheUserPosts(List<Map<String, dynamic>> posts) async {
    try {
      await cacheStore.set(
        AppCacheBoxes.profileBox,
        AppCacheKeys.userPosts,
        posts,
      );
    } catch (_) {}
  }

  @override
  Future<List<TimelineItemEntity>> getCachedUserPosts() async {
    try {
      final cached = await cacheStore.get<List<dynamic>>(
        AppCacheBoxes.profileBox,
        AppCacheKeys.userPosts,
      );
      if (cached != null) {
        return cached
            .whereType<Map<String, dynamic>>()
            .map((e) => TimelineItemModel.fromJson(e).toEntity())
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> cacheSavedPosts(List<Map<String, dynamic>> posts) async {
    try {
      await cacheStore.set(
        AppCacheBoxes.profileBox,
        AppCacheKeys.savedPosts,
        posts,
      );
    } catch (_) {}
  }

  @override
  Future<List<TimelineItemEntity>> getCachedSavedPosts() async {
    try {
      final cached = await cacheStore.get<List<dynamic>>(
        AppCacheBoxes.profileBox,
        AppCacheKeys.savedPosts,
      );
      if (cached != null) {
        return cached
            .whereType<Map<String, dynamic>>()
            .map((e) => TimelineItemModel.fromJson(e).toEntity())
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}

