import '../entities/brand_partner_entity.dart';
import '../entities/timeline_item_entity.dart';
import '../entities/timeline_pagination_entity.dart';

abstract class HomeRepository {
  Future<({List<TimelineItemEntity> items, TimelinePaginationEntity pagination})>
  getTimelineFeed({int page = 1, int perPage = 20, String? filter});

  Future<List<BrandPartnerEntity>> getBrandPartners();

  Future<bool> toggleLike(String postId, {required bool isCurrentlyLiked});

  Future<bool> toggleSave(String postId, {required bool isCurrentlySaved});
}
