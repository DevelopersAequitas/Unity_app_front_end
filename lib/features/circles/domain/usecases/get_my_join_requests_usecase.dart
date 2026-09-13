import '../entities/circle_join_request_entity.dart';
import '../repositories/circles_repository.dart';

class GetMyJoinRequestsUseCase {
  final CirclesRepository repository;

  const GetMyJoinRequestsUseCase(this.repository);

  Future<List<CircleJoinRequestEntity>> call() {
    return repository.getMyJoinRequests();
  }
}
