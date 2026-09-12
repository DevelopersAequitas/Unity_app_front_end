import 'dart:io';
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
    return remoteDataSource.getUserPosts(page: page);
  }

  @override
  Future<String> uploadFile(File file) async {
    return remoteDataSource.uploadFile(file);
  }
}
