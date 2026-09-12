import '../models/register_request_model.dart';
import '../../domain/entities/category_item_entity.dart';
import '../../domain/entities/register_params.dart';

import '../../domain/entities/auth_token_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> requestOtp(String email, {String channel = 'email'}) async {
    await remoteDataSource.requestOtp(email, channel: channel);
  }

  @override
  Future<({UserEntity user, AuthTokenEntity token})> verifyOtp({
    required String email,
    required String otp,
    required String deviceName,
  }) async {
    final response = await remoteDataSource.verifyOtp(
      email: email,
      otp: otp,
      deviceName: deviceName,
    );

    final userModel =
        response.user ?? UserModel(id: 'usr_default', email: email);
    final tokenStr = response.token ?? 'fallback_token';

    // Store in offline cache box
    await localDataSource.saveAuthData(user: userModel, token: tokenStr);

    return (
      user: userModel.toEntity(),
      token: AuthTokenEntity(token: tokenStr),
    );
  }

  @override
  Future<({UserEntity user, AuthTokenEntity token})> register(
    RegisterParams params,
  ) async {
    final requestModel = RegisterRequestModel.fromEntity(params);
    final response = await remoteDataSource.register(requestModel);

    final userModel =
        response.user ??
        UserModel(
          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
          email: params.email,
          name: '${params.firstName} ${params.lastName}'.trim(),
        );
    final tokenStr = response.token ?? 'fallback_token';

    // Store in offline cache box
    await localDataSource.saveAuthData(user: userModel, token: tokenStr);

    // Sync company geolocation on 1st registration to enable near me peers immediately
    if (params.latitude != null && params.longitude != null) {
      try {
        await remoteDataSource.updateGeoLocation(
          latitude: params.latitude!,
          longitude: params.longitude!,
          token: tokenStr,
        );
      } catch (_) {
        // Safe failover
      }
    }

    return (
      user: userModel.toEntity(),
      token: AuthTokenEntity(token: tokenStr),
    );
  }

  @override
  Future<List<CategoryItemEntity>> getMainCategories() async {
    final models = await remoteDataSource.getMainBusinessCategories();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<CategoryItemEntity>> getSubcategories(dynamic parentId) async {
    final models = await remoteDataSource.getSubcategories(parentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveRegistrationDraft(RegisterParams params) async {
    await localDataSource.saveRegistrationDraft(params.toCacheMap());
  }

  @override
  Future<RegisterParams?> getRegistrationDraft() async {
    final map = await localDataSource.getRegistrationDraft();
    if (map != null) {
      return RegisterParams.fromCacheMap(map);
    }
    return null;
  }

  @override
  Future<void> clearRegistrationDraft() async {
    await localDataSource.clearRegistrationDraft();
  }

  @override
  Future<({UserEntity? user, AuthTokenEntity? token})> getCachedAuth() async {
    final localData = await localDataSource.getAuthData();
    return (
      user: localData.user?.toEntity(),
      token: localData.token != null
          ? AuthTokenEntity(token: localData.token!)
          : null,
    );
  }

  @override
  Future<void> clearAuth() async {
    await localDataSource.clearAuthData();
  }
}
