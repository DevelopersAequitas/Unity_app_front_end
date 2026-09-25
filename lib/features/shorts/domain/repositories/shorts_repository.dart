import '../entities/intro_video_entity.dart';

/// Domain-level result for paginated intro videos.
class ShortsPageResult {
  final List<IntroVideoEntity> videos;
  final int? total;

  const ShortsPageResult({required this.videos, this.total});
}

abstract class ShortsRepository {
  Future<ShortsPageResult> getIntroVideos({
    int page = 1,
    int perPage = 10,
  });

  Future<List<IntroVideoEntity>> getCachedShorts();

  Future<bool> toggleLike(String introVideoId, bool currentStatus);

  Future<bool> toggleBookmark(String memberId, bool currentStatus);

  Future<bool> toggleFollow(String memberId, bool currentStatus);
}
