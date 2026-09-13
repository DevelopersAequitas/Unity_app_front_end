import 'dart:io';
import '../entities/brand_partner_entity.dart';
import '../entities/post_comment_entity.dart';
import '../entities/post_like_entity.dart';
import '../entities/timeline_item_entity.dart';
import '../entities/timeline_pagination_entity.dart';

abstract class HomeRepository {
  Future<({List<TimelineItemEntity> items, TimelinePaginationEntity pagination})>
  getTimelineFeed({int page = 1, int perPage = 20, String? filter});

  Future<({List<TimelineItemEntity> items, TimelinePaginationEntity pagination})?> getCachedTimelineFeed();

  Future<List<BrandPartnerEntity>> getBrandPartners();

  Future<List<BrandPartnerEntity>> getCachedBrandPartners();

  Future<bool> toggleLike(String postId, {required bool isCurrentlyLiked});

  Future<bool> toggleSave(String postId, {required bool isCurrentlySaved});

  Future<List<PostLikeEntity>> getPostLikes(String postId, {int page = 1});

  Future<List<PostCommentEntity>> getPostComments(String postId, {int page = 1});

  Future<PostCommentEntity> addPostComment(String postId, String content);

  Future<String> uploadFile(File file, {void Function(double progress)? onProgress});

  Future<void> createPost({
    required String contentText,
    String visibility = 'public',
    List<Map<String, String>> media = const [],
  });

  Future<void> deletePost(String postId);

  Future<void> updatePost(String postId, {required String contentText});
}
