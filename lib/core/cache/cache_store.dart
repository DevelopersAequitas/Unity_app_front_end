abstract class CacheStore {
  Future<void> init();
  Future<void> set(String boxName, String key, dynamic value);
  Future<T?> get<T>(String boxName, String key);
  Future<void> delete(String boxName, String key);
  Future<void> clear(String boxName);
  Future<bool> has(String boxName, String key);
  Future<Map<String, dynamic>> getAll(String boxName);
  Future<void> setWithExpiry(
    String boxName,
    String key,
    dynamic value, {
    required Duration ttl,
  });
}
