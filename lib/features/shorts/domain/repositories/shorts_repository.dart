import '../entities/intro_video_entity.dart';

abstract class ShortsRepository {
  Future<List<IntroVideoEntity>> getIntroVideos({
    int page = 1,
    int perPage = 10,
  });

  Future<bool> toggleLike(String introVideoId, bool currentStatus);

  Future<bool> toggleBookmark(String memberId, bool currentStatus);

  Future<bool> toggleFollow(String memberId, bool currentStatus);
}
