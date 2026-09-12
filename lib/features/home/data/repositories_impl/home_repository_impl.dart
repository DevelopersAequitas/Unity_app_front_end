import '../../domain/entities/brand_partner_entity.dart';
import '../../domain/entities/timeline_item_entity.dart';
import '../../domain/entities/timeline_pagination_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource? localDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<({List<TimelineItemEntity> items, TimelinePaginationEntity pagination})>
  getTimelineFeed({int page = 1, int perPage = 20, String? filter}) async {
    try {
      final response = await remoteDataSource.getTimelineFeed(
        page: page,
        perPage: perPage,
        filter: filter,
      );

      if (page == 1 && (filter == null || filter.isEmpty || filter == 'All')) {
        if (response.rawJson != null && localDataSource != null) {
          await localDataSource!.cacheTimelineFeed(response.rawJson!);
        }
      }

      return (
        items: response.items.map((m) => m.toEntity()).toList(),
        pagination: response.toPaginationEntity(),
      );
    } catch (e) {
      if (page == 1 && localDataSource != null) {
        final cached = await localDataSource!.getCachedTimelineFeed();
        if (cached != null && cached.items.isNotEmpty) {
          return (
            items: cached.items.map((m) => m.toEntity()).toList(),
            pagination: cached.toPaginationEntity(),
          );
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<BrandPartnerEntity>> getBrandPartners() async {
    try {
      final list = await remoteDataSource.getBrandPartners();
      return list.map((m) => m.toEntity()).toList();
    } catch (_) {
      if (localDataSource != null) {
        final cached = await localDataSource!.getCachedBrandPartners();
        return cached.map((m) => m.toEntity()).toList();
      }
      return [];
    }
  }

  @override
  Future<bool> toggleLike(String postId, {required bool isCurrentlyLiked}) async {
    if (isCurrentlyLiked) {
      await remoteDataSource.unlikePost(postId);
      return false;
    } else {
      await remoteDataSource.likePost(postId);
      return true;
    }
  }

  @override
  Future<bool> toggleSave(String postId, {required bool isCurrentlySaved}) async {
    await remoteDataSource.toggleSavePost(postId);
    return !isCurrentlySaved;
  }
}
