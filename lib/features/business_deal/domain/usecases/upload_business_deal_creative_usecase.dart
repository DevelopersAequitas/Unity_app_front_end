import 'dart:io';
import '../repositories/business_deals_repository.dart';

class UploadBusinessDealCreativeUseCase {
  final BusinessDealsRepository repository;

  const UploadBusinessDealCreativeUseCase(this.repository);

  Future<void> call({
    required String activityId,
    required String postId,
    required File creativeImage,
  }) {
    return repository.uploadActivityCreative(
      activityId: activityId,
      postId: postId,
      creativeImage: creativeImage,
    );
  }
}
