import '../repositories/circles_repository.dart';

class LeaveCircleUseCase {
  final CirclesRepository repository;

  LeaveCircleUseCase(this.repository);

  Future<bool> call(String circleId) {
    return repository.leaveCircle(circleId);
  }
}
