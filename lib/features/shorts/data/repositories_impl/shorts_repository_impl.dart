import '../../domain/entities/intro_video_entity.dart';
import '../../domain/repositories/shorts_repository.dart';
import '../datasources/shorts_remote_datasource.dart';

class ShortsRepositoryImpl implements ShortsRepository {
  final ShortsRemoteDataSource remoteDataSource;

  ShortsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<IntroVideoEntity>> getIntroVideos({
    int page = 1,
    int perPage = 10,
  }) async {
    return await remoteDataSource.getIntroVideos(
      page: page,
      perPage: perPage,
    );
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
