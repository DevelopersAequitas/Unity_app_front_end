import 'dart:convert';
import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<void> clearCachedProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final CacheStore cacheStore;

  ProfileLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<ProfileModel?> getCachedProfile() async {
    try {
      final raw = await cacheStore.get<String>(
        AppCacheBoxes.authBox,
        'cached_user_profile',
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
        'cached_user_profile',
        jsonEncode(profile.toJson()),
      );
    } catch (_) {}
  }

  @override
  Future<void> clearCachedProfile() async {
    try {
      await cacheStore.delete(
        AppCacheBoxes.authBox,
        'cached_user_profile',
      );
    } catch (_) {}
  }
}
