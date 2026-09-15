import '../repositories/circles_repository.dart';

class CancelCircleJoinRequestUseCase {
  final CirclesRepository repository;

  CancelCircleJoinRequestUseCase(this.repository);

  Future<bool> call(String requestId) {
    return repository.cancelCircleJoinRequest(requestId);
  }
}
