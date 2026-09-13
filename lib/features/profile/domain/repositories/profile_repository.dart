import 'dart:io';
import '../../../home/domain/entities/timeline_item_entity.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile({bool forceRefresh = false});
  Future<ProfileEntity> updateProfile(Map<String, dynamic> data);
  Future<List<TimelineItemEntity>> getUserPosts({int page = 1});
  Future<List<TimelineItemEntity>> getSavedPosts({int page = 1});
  Future<String> uploadFile(File file, {void Function(double progress)? onProgress});
}
