import '../entities/circle_category_entity.dart';
import '../entities/circle_entity.dart';
import '../entities/circle_join_request_entity.dart';
import '../entities/circle_member_entity.dart';

abstract class CirclesRepository {
  Future<List<CircleEntity>> getMyCircles();
  Future<List<CircleCategoryEntity>> getCircleCategories();
  Future<CircleEntity> getCircleDetail(String id);
  Future<List<CircleMemberEntity>> getCircleMembers(String circleId);
  Future<List<CircleCategoryEntity>> getCategorySubcategories(String categoryId);
  Future<CircleJoinRequestEntity> submitJoinRequest({
    required String circleId,
    required String reason,
    dynamic categoryId,
    dynamic level4CategoryId,
    String? customCategoryName,
  });
  Future<List<CircleJoinRequestEntity>> getMyJoinRequests();
  Future<List<CircleEntity>> getCachedMyCircles();
  Future<List<CircleCategoryEntity>> getCachedCircleCategories();
}
