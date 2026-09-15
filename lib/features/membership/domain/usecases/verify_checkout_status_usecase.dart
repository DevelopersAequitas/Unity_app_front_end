import '../entities/subscription_status_entity.dart';
import '../repositories/membership_repository.dart';

class VerifyCheckoutStatusUseCase {
  final MembershipRepository repository;

  VerifyCheckoutStatusUseCase(this.repository);

  Future<SubscriptionStatusEntity> call(String hostedPageId) {
    return repository.verifyCheckoutStatus(hostedPageId);
  }
}
