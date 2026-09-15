import '../entities/circle_join_request_entity.dart';
import '../repositories/circles_repository.dart';

class GetCircleJoinRequestStatusUseCase {
  final CirclesRepository repository;

  GetCircleJoinRequestStatusUseCase(this.repository);

  Future<CircleJoinRequestEntity> call(String requestId) {
    return repository.getCircleJoinRequestStatus(requestId);
  }
}
