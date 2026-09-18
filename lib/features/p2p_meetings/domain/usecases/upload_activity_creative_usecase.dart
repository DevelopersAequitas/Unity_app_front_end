import 'dart:io';
import '../repositories/p2p_meetings_repository.dart';

class UploadActivityCreativeUseCase {
  final P2pMeetingsRepository repository;

  const UploadActivityCreativeUseCase(this.repository);

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
