import '../entities/checkout_session_entity.dart';
import '../repositories/membership_repository.dart';

class InitiatePlanCheckoutUseCase {
  final MembershipRepository repository;

  InitiatePlanCheckoutUseCase(this.repository);

  Future<CheckoutSessionEntity> call(String planCode) {
    return repository.initiatePlanCheckout(planCode);
  }
}
