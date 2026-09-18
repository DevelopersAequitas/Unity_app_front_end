import '../entities/referral_status_entity.dart';
import '../repositories/referrals_repository.dart';

class GetReferralStatusesUseCase {
  final ReferralsRepository repository;

  GetReferralStatusesUseCase(this.repository);

  Future<List<ReferralStatusEntity>> call() {
    return repository.getReferralStatuses();
  }
}
