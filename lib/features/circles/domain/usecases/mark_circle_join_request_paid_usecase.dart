import '../entities/circle_join_request_entity.dart';
import '../repositories/circles_repository.dart';

class MarkCircleJoinRequestPaidUseCase {
  final CirclesRepository repository;

  MarkCircleJoinRequestPaidUseCase(this.repository);

  Future<CircleJoinRequestEntity> call(String requestId) {
    return repository.markCircleJoinRequestPaid(requestId);
  }
}
