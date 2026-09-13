import '../entities/circle_entity.dart';
import '../repositories/circles_repository.dart';

class GetCircleDetailUseCase {
  final CirclesRepository repository;

  GetCircleDetailUseCase(this.repository);

  Future<CircleEntity> call(String id) => repository.getCircleDetail(id);
}
