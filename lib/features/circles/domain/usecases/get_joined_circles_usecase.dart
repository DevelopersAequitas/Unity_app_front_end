import '../entities/circle_entity.dart';
import '../repositories/circles_repository.dart';

class GetJoinedCirclesUseCase {
  final CirclesRepository repository;

  GetJoinedCirclesUseCase(this.repository);

  Future<List<CircleEntity>> call() {
    return repository.getJoinedCircles();
  }
}
