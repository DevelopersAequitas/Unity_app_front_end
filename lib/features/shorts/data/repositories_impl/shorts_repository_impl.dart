import '../../domain/entities/intro_video_entity.dart';
import '../../domain/repositories/shorts_repository.dart';
import '../datasources/shorts_local_datasource.dart';
import '../datasources/shorts_remote_datasource.dart';

class ShortsRepositoryImpl implements ShortsRepository {
  final ShortsRemoteDataSource remoteDataSource;
  final ShortsLocalDataSource? localDataSource;

  ShortsRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<ShortsPageResult> getIntroVideos({
    int page = 1,
    int perPage = 10,
  }) async {
    final result = await remoteDataSource.getIntroVideos(
      page: page,
      perPage: perPage,
    );

    if (page == 1 && result.videos.isNotEmpty && localDataSource != null) {
      final rawList = result.videos.map((m) => m.toJson()).toList();
      await localDataSource!.cacheShorts(rawList);
    }

    return ShortsPageResult(
      videos: result.videos,
      total: result.total,
    );
  }

  @override
  Future<List<IntroVideoEntity>> getCachedShorts() async {
    if (localDataSource != null) {
      return await localDataSource!.getCachedShorts();
    }
    return [];
  }

  @override
  Future<bool> toggleLike(String introVideoId, bool currentStatus) async {
    return await remoteDataSource.toggleLike(introVideoId, currentStatus);
  }

  @override
  Future<bool> toggleBookmark(String memberId, bool currentStatus) async {
    return await remoteDataSource.toggleBookmark(memberId, currentStatus);
  }

  @override
  Future<bool> toggleFollow(String memberId, bool currentStatus) async {
    return await remoteDataSource.toggleFollow(memberId, currentStatus);
  }
}
