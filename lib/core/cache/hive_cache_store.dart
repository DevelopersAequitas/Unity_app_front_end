import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'cache_store.dart';

class HiveCacheStore implements CacheStore {
  final Map<String, Box> _openBoxes = {};

  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<Box> _getBox(String boxName) async {
    if (_openBoxes.containsKey(boxName) && _openBoxes[boxName]!.isOpen) {
      return _openBoxes[boxName]!;
    }
    final box = await Hive.openBox(boxName);
    _openBoxes[boxName] = box;
    return box;
  }

  @override
  Future<void> set(String boxName, String key, dynamic value) async {
    final box = await _getBox(boxName);
    if (value is Map || value is List) {
      await box.put(key, jsonEncode(value));
    } else {
      await box.put(key, value);
    }
  }

  @override
  Future<T?> get<T>(String boxName, String key) async {
    final box = await _getBox(boxName);
    final dynamic raw = box.get(key);
    if (raw == null) return null;

    if (raw is String && T != String) {
      try {
        final dynamic decoded = jsonDecode(raw);
        if (decoded is T) return decoded;
      } catch (_) {}
    }

    if (raw is T) return raw;
    return null;
  }

  @override
  Future<void> delete(String boxName, String key) async {
    final box = await _getBox(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clear(String boxName) async {
    final box = await _getBox(boxName);
    await box.clear();
  }

  @override
  Future<bool> has(String boxName, String key) async {
    final box = await _getBox(boxName);
    return box.containsKey(key);
  }

  @override
  Future<Map<String, dynamic>> getAll(String boxName) async {
    final box = await _getBox(boxName);
    final Map<String, dynamic> result = {};
    for (final key in box.keys) {
      result[key.toString()] = box.get(key);
    }
    return result;
  }

  @override
  Future<void> setWithExpiry(
    String boxName,
    String key,
    dynamic value, {
    required Duration ttl,
  }) async {
    final payload = {
      'data': value,
      'expires_at': DateTime.now().add(ttl).toIso8601String(),
    };
    await set(boxName, key, payload);
  }
}
