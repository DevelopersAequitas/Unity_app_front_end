import '../entities/circle_category_entity.dart';
import '../entities/circle_closed_category_entity.dart';
import '../entities/circle_entity.dart';
import '../entities/circle_join_request_entity.dart';
import '../entities/circle_member_entity.dart';
import '../entities/circle_open_category_entity.dart';
import '../entities/circle_package_entity.dart';

abstract class CirclesRepository {
  Future<List<CircleEntity>> getMyCircles();
  Future<List<CircleEntity>> getJoinedCircles();
  Future<CirclePackageEntity> getCirclePackage(String circleId);
  Future<List<CircleCategoryEntity>> getCircleCategories();
  Future<CircleEntity> getCircleDetail(String id);
  Future<List<CircleMemberEntity>> getCircleMembers(String circleId);
  Future<List<CircleCategoryEntity>> getCategorySubcategories(String categoryId);
  Future<List<CircleOpenCategoryEntity>> getCircleOpenCategories(String circleId);
  Future<List<CircleClosedCategoryEntity>> getCircleClosedCategories(String circleId);
  Future<CircleJoinRequestEntity> submitJoinRequest({
    required String circleId,
    required String reason,
    dynamic categoryId,
    dynamic level4CategoryId,
    bool isOtherCategory = false,
    String? customCategoryName,
  });
  Future<List<CircleJoinRequestEntity>> getMyJoinRequests();
  Future<CircleJoinRequestEntity> getCircleJoinRequestStatus(String requestId);
  Future<bool> cancelCircleJoinRequest(String requestId);
  Future<String> getCircleCheckoutUrl(String circleId);
  Future<CircleJoinRequestEntity> markCircleJoinRequestPaid(String requestId);
  Future<bool> leaveCircle(String circleId);
  Future<List<CircleEntity>> getCachedMyCircles();
  Future<List<CircleCategoryEntity>> getCachedCircleCategories();
}

