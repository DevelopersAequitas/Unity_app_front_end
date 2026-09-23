import 'dart:io';
import '../../../home/data/models/timeline_item_model.dart';
import '../../../home/domain/entities/timeline_item_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<ProfileEntity> getProfile({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await localDataSource.getCachedProfile();
      if (cached != null) {
        _refreshInBackground();
        return cached;
      }
    }

    final remoteProfile = await remoteDataSource.getProfile();
    await localDataSource.cacheProfile(remoteProfile);
    return remoteProfile;
  }

  void _refreshInBackground() async {
    try {
      final remoteProfile = await remoteDataSource.getProfile();
      await localDataSource.cacheProfile(remoteProfile);
    } catch (_) {}
  }

  @override
  Future<ProfileEntity> updateProfile(Map<String, dynamic> data) async {
    final updated = await remoteDataSource.updateProfile(data);
    await localDataSource.cacheProfile(updated);
    return updated;
  }

  @override
  Future<List<TimelineItemEntity>> getUserPosts({int page = 1}) async {
    if (page == 1) {
      final cached = await localDataSource.getCachedUserPosts();
      if (cached.isNotEmpty) {
        _refreshUserPostsInBackground();
        return cached;
      }
    }

    final raw = await remoteDataSource.getUserPostsRaw(page: page);
    if (page == 1 && raw.isNotEmpty) {
      await localDataSource.cacheUserPosts(raw);
    }
    return raw.map((json) => TimelineItemModel.fromJson(json).toEntity()).toList();
  }

  void _refreshUserPostsInBackground() async {
    try {
      final raw = await remoteDataSource.getUserPostsRaw(page: 1);
      if (raw.isNotEmpty) {
        await localDataSource.cacheUserPosts(raw);
      }
    } catch (_) {}
  }

  @override
  Future<List<TimelineItemEntity>> getSavedPosts({int page = 1}) async {
    if (page == 1) {
      final cached = await localDataSource.getCachedSavedPosts();
      if (cached.isNotEmpty) {
        _refreshSavedPostsInBackground();
        return cached;
      }
    }

    final raw = await remoteDataSource.getSavedPostsRaw(page: page);
    if (page == 1 && raw.isNotEmpty) {
      await localDataSource.cacheSavedPosts(raw);
    }
    return raw.map((json) => TimelineItemModel.fromJson(json).toEntity()).toList();
  }

  void _refreshSavedPostsInBackground() async {
    try {
      final raw = await remoteDataSource.getSavedPostsRaw(page: 1);
      if (raw.isNotEmpty) {
        await localDataSource.cacheSavedPosts(raw);
      }
    } catch (_) {}
  }

  @override
  Future<String> uploadFile(File file, {void Function(double progress)? onProgress}) async {
    return remoteDataSource.uploadFile(file, onProgress: onProgress);
  }
}
