import 'dart:io';
import '../../domain/entities/brand_partner_entity.dart';
import '../../domain/entities/post_comment_entity.dart';
import '../../domain/entities/post_like_entity.dart';
import '../../domain/entities/post_report_reason_entity.dart';
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
  Future<({List<TimelineItemEntity> items, TimelinePaginationEntity pagination})?>
  getCachedTimelineFeed() async {
    if (localDataSource == null) return null;
    final cached = await localDataSource!.getCachedTimelineFeed();
    if (cached != null && cached.items.isNotEmpty) {
      return (
        items: cached.items.map((m) => m.toEntity()).toList(),
        pagination: cached.toPaginationEntity(),
      );
    }
    return null;
  }

  @override
  Future<List<BrandPartnerEntity>> getBrandPartners() async {
    try {
      final list = await remoteDataSource.getBrandPartners();
      if (localDataSource != null) {
        await localDataSource!.cacheBrandPartners(list.map((m) => m.toJson()).toList());
      }
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
  Future<List<BrandPartnerEntity>> getCachedBrandPartners() async {
    if (localDataSource == null) return [];
    final cached = await localDataSource!.getCachedBrandPartners();
    return cached.map((m) => m.toEntity()).toList();
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

  @override
  Future<List<PostLikeEntity>> getPostLikes(String postId, {int page = 1}) async {
    final list = await remoteDataSource.getPostLikes(postId, page: page);
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PostCommentEntity>> getPostComments(String postId, {int page = 1}) async {
    final list = await remoteDataSource.getPostComments(postId, page: page);
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<PostCommentEntity> addPostComment(String postId, String content) async {
    final model = await remoteDataSource.addPostComment(postId, content);
    return model.toEntity();
  }

  @override
  Future<String> uploadFile(File file, {void Function(double progress)? onProgress}) {
    return remoteDataSource.uploadFile(file, onProgress: onProgress);
  }

  @override
  Future<void> createPost({
    required String contentText,
    String visibility = 'public',
    List<Map<String, String>> media = const [],
    List<Map<String, dynamic>> mentions = const [],
  }) {
    return remoteDataSource.createPost(
      contentText: contentText,
      visibility: visibility,
      media: media,
      mentions: mentions,
    );
  }

  @override
  Future<void> deletePost(String postId) {
    return remoteDataSource.deletePost(postId);
  }

  @override
  Future<void> updatePost(String postId, {required String contentText}) {
    return remoteDataSource.updatePost(postId, contentText: contentText);
  }

  @override
  Future<List<PostReportReasonEntity>> getPostReportReasons() {
    return remoteDataSource.getPostReportReasons();
  }

  @override
  Future<void> reportPost(String postId, int reasonId) {
    return remoteDataSource.reportPost(postId, reasonId);
  }
}
