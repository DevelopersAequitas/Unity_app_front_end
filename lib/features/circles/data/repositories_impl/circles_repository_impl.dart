import 'package:unity_app/features/circles/domain/entities/circle_join_request_entity.dart';
import 'package:unity_app/features/circles/domain/entities/circle_member_entity.dart';

import '../../domain/entities/circle_category_entity.dart';
import '../../domain/entities/circle_closed_category_entity.dart';
import '../../domain/entities/circle_entity.dart';
import '../../domain/entities/circle_open_category_entity.dart';
import '../../domain/repositories/circles_repository.dart';
import '../datasources/circles_local_datasource.dart';
import '../datasources/circles_remote_datasource.dart';

class CirclesRepositoryImpl implements CirclesRepository {
  final CirclesRemoteDataSource remoteDataSource;
  final CirclesLocalDataSource localDataSource;

  CirclesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CircleEntity>> getMyCircles() async {
    try {
      final models = await remoteDataSource.getMyCircles();
      await localDataSource.cacheMyCircles(models);
      return models;
    } catch (_) {
      final cached = await localDataSource.getCachedMyCircles();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<List<CircleCategoryEntity>> getCircleCategories() async {
    try {
      final models = await remoteDataSource.getCircleCategories();
      await localDataSource.cacheCircleCategories(models);
      return models;
    } catch (_) {
      final cached = await localDataSource.getCachedCircleCategories();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<CircleEntity> getCircleDetail(String id) async {
    return await remoteDataSource.getCircleDetail(id);
  }

  @override
  Future<List<CircleMemberEntity>> getCircleMembers(String circleId) async {
    return await remoteDataSource.getCircleMembers(circleId);
  }

  @override
  Future<List<CircleCategoryEntity>> getCategorySubcategories(String categoryId) async {
    return await remoteDataSource.getCategorySubcategories(categoryId);
  }

  @override
  Future<List<CircleOpenCategoryEntity>> getCircleOpenCategories(String circleId) async {
    return await remoteDataSource.getCircleOpenCategories(circleId);
  }

  @override
  Future<List<CircleClosedCategoryEntity>> getCircleClosedCategories(String circleId) async {
    return await remoteDataSource.getCircleClosedCategories(circleId);
  }

  @override
  Future<CircleJoinRequestEntity> submitJoinRequest({
    required String circleId,
    required String reason,
    dynamic categoryId,
    dynamic level4CategoryId,
    String? customCategoryName,
  }) async {
    return await remoteDataSource.submitJoinRequest(
      circleId: circleId,
      reason: reason,
      categoryId: categoryId,
      level4CategoryId: level4CategoryId,
      customCategoryName: customCategoryName,
    );
  }

  @override
  Future<List<CircleJoinRequestEntity>> getMyJoinRequests() async {
    return await remoteDataSource.getMyJoinRequests();
  }

  @override
  Future<CircleJoinRequestEntity> getCircleJoinRequestStatus(String requestId) async {
    return await remoteDataSource.getCircleJoinRequestStatus(requestId);
  }

  @override
  Future<bool> cancelCircleJoinRequest(String requestId) async {
    return await remoteDataSource.cancelCircleJoinRequest(requestId);
  }

  @override
  Future<List<CircleEntity>> getCachedMyCircles() =>
      localDataSource.getCachedMyCircles();

  @override
  Future<List<CircleCategoryEntity>> getCachedCircleCategories() =>
      localDataSource.getCachedCircleCategories();
}

