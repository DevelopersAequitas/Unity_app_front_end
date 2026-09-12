import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData({required UserModel user, required String token});

  Future<({UserModel? user, String? token})> getAuthData();

  Future<void> clearAuthData();

  Future<void> saveRegistrationDraft(Map<String, dynamic> data);

  Future<Map<String, dynamic>?> getRegistrationDraft();

  Future<void> clearRegistrationDraft();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final CacheStore cacheStore;

  AuthLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<void> saveAuthData({
    required UserModel user,
    required String token,
  }) async {
    await cacheStore.set(AppCacheBoxes.authBox, AppCacheKeys.authToken, token);
    await cacheStore.set(
      AppCacheBoxes.authBox,
      AppCacheKeys.authUser,
      user.toJson(),
    );
    await cacheStore.set(
      AppCacheBoxes.authBox,
      AppCacheKeys.lastActiveEmail,
      user.email,
    );
  }

  @override
  Future<({UserModel? user, String? token})> getAuthData() async {
    final token = await cacheStore.get<String>(
      AppCacheBoxes.authBox,
      AppCacheKeys.authToken,
    );
    final userMap = await cacheStore.get<Map<String, dynamic>>(
      AppCacheBoxes.authBox,
      AppCacheKeys.authUser,
    );

    UserModel? user;
    if (userMap != null) {
      try {
        user = UserModel.fromJson(userMap);
      } catch (_) {}
    }

    return (user: user, token: token);
  }

  @override
  Future<void> clearAuthData() async {
    await cacheStore.clear(AppCacheBoxes.authBox);
  }

  @override
  Future<void> saveRegistrationDraft(Map<String, dynamic> data) async {
    await cacheStore.set(
      AppCacheBoxes.appCacheBox,
      AppCacheKeys.registrationDraft,
      data,
    );
  }

  @override
  Future<Map<String, dynamic>?> getRegistrationDraft() async {
    return cacheStore.get<Map<String, dynamic>>(
      AppCacheBoxes.appCacheBox,
      AppCacheKeys.registrationDraft,
    );
  }

  @override
  Future<void> clearRegistrationDraft() async {
    await cacheStore.delete(
      AppCacheBoxes.appCacheBox,
      AppCacheKeys.registrationDraft,
    );
  }
}
