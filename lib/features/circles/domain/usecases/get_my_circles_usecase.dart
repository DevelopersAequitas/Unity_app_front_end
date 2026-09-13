import '../entities/circle_entity.dart';
import '../repositories/circles_repository.dart';

class GetMyCirclesUseCase {
  final CirclesRepository repository;

  GetMyCirclesUseCase(this.repository);

  Future<List<CircleEntity>> call() => repository.getMyCircles();
}
