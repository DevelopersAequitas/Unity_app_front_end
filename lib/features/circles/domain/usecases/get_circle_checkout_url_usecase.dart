import '../repositories/circles_repository.dart';

class GetCircleCheckoutUrlUseCase {
  final CirclesRepository repository;

  GetCircleCheckoutUrlUseCase(this.repository);

  Future<String> call(String circleId) {
    return repository.getCircleCheckoutUrl(circleId);
  }
}
