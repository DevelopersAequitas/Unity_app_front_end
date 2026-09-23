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
  Future<List<IntroVideoEntity>> getIntroVideos({
    int page = 1,
    int perPage = 10,
  }) async {
    final remoteVideos = await remoteDataSource.getIntroVideos(
      page: page,
      perPage: perPage,
    );

    if (page == 1 && remoteVideos.isNotEmpty && localDataSource != null) {
      final rawList = remoteVideos.map((m) => m.toJson()).toList();
      await localDataSource!.cacheShorts(rawList);
    }

    return remoteVideos;
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
