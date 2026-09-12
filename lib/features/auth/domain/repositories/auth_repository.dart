import '../entities/auth_token_entity.dart';
import '../entities/category_item_entity.dart';
import '../entities/register_params.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> requestOtp(String email, {String channel = 'email'});

  Future<({UserEntity user, AuthTokenEntity token})> verifyOtp({
    required String email,
    required String otp,
    required String deviceName,
  });

  Future<({UserEntity user, AuthTokenEntity token})> register(
    RegisterParams params,
  );

  Future<List<CategoryItemEntity>> getMainCategories();

  Future<List<CategoryItemEntity>> getSubcategories(dynamic parentId);

  Future<void> saveRegistrationDraft(RegisterParams params);

  Future<RegisterParams?> getRegistrationDraft();

  Future<void> clearRegistrationDraft();

  Future<({UserEntity? user, AuthTokenEntity? token})> getCachedAuth();

  Future<void> clearAuth();
}
