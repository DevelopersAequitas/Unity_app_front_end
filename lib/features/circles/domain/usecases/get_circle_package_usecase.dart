import '../entities/circle_package_entity.dart';
import '../repositories/circles_repository.dart';

class GetCirclePackageUseCase {
  final CirclesRepository repository;

  GetCirclePackageUseCase(this.repository);

  Future<CirclePackageEntity> call(String circleId) {
    return repository.getCirclePackage(circleId);
  }
}
