import '../entities/subscription_history_entity.dart';
import '../repositories/membership_repository.dart';

class GetSubscriptionHistoryUseCase {
  final MembershipRepository repository;

  GetSubscriptionHistoryUseCase(this.repository);

  Future<List<SubscriptionHistoryEntity>> call() {
    return repository.getSubscriptionHistory();
  }
}
