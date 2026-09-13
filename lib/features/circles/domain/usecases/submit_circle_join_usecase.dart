import '../entities/circle_join_request_entity.dart';
import '../repositories/circles_repository.dart';

class SubmitCircleJoinUseCase {
  final CirclesRepository repository;

  const SubmitCircleJoinUseCase(this.repository);

  Future<CircleJoinRequestEntity> call({
    required String circleId,
    required String reason,
    dynamic categoryId,
    dynamic level4CategoryId,
    String? customCategoryName,
  }) {
    return repository.submitJoinRequest(
      circleId: circleId,
      reason: reason,
      categoryId: categoryId,
      level4CategoryId: level4CategoryId,
      customCategoryName: customCategoryName,
    );
  }
}
