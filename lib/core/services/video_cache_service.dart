import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class VideoCacheService {
  static final VideoCacheService _instance = VideoCacheService._internal();
  factory VideoCacheService() => _instance;
  VideoCacheService._internal();

  static const String cacheKey = 'app_videos_cache';

  static final CacheManager _cacheManager = CacheManager(
    Config(
      cacheKey,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 200,
      repo: JsonCacheInfoRepository(databaseName: cacheKey),
      fileService: HttpFileService(),
    ),
  );

  /// Returns cached File if available on disk, otherwise null.
  Future<File?> getCachedVideoFile(String url) async {
    if (url.isEmpty) return null;
    try {
      final fileInfo = await _cacheManager.getFileFromCache(url);
      if (fileInfo != null && await fileInfo.file.exists()) {
        return fileInfo.file;
      }
    } catch (e) {
      debugPrint('[VideoCacheService] Error getting cached file for $url: $e');
    }
    return null;
  }

  /// Downloads and caches the video file, returning the local [File].
  Future<File?> downloadAndCacheVideo(String url) async {
    if (url.isEmpty) return null;
    try {
      final fileInfo = await _cacheManager.downloadFile(url);
      return fileInfo.file;
    } catch (e) {
      debugPrint('[VideoCacheService] Error caching video for $url: $e');
      return null;
    }
  }

  /// Gets single file from cache or downloads it.
  Future<File?> getOrFetchVideoFile(String url) async {
    if (url.isEmpty) return null;
    try {
      return await _cacheManager.getSingleFile(url);
    } catch (e) {
      debugPrint('[VideoCacheService] Error getOrFetch for $url: $e');
      return null;
    }
  }

  /// Preload/prefetch a video in the background without blocking.
  void preloadVideo(String url) {
    if (url.isEmpty) return;
    getCachedVideoFile(url).then((file) {
      if (file == null) {
        _cacheManager.downloadFile(url).then((_) {}, onError: (e) {
          debugPrint('[VideoCacheService] Preload error for $url: $e');
        });
      }
    });
  }

  /// Preload adjacent videos (next 2 and previous 1) around the current index.
  void preloadAdjacentVideos(List<String> urls, int currentIndex) {
    if (urls.isEmpty) return;

    // Next 2 videos
    for (int i = 1; i <= 2; i++) {
      final nextIdx = currentIndex + i;
      if (nextIdx < urls.length) {
        preloadVideo(urls[nextIdx]);
      }
    }

    // Previous 1 video
    final prevIdx = currentIndex - 1;
    if (prevIdx >= 0 && prevIdx < urls.length) {
      preloadVideo(urls[prevIdx]);
    }
  }
}
