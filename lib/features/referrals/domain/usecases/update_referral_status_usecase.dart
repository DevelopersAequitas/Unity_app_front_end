import '../entities/referral_entity.dart';
import '../repositories/referrals_repository.dart';

class UpdateReferralStatusUseCase {
  final ReferralsRepository repository;

  UpdateReferralStatusUseCase(this.repository);

  Future<ReferralEntity> call({required String id, required int statusId}) {
    return repository.updateReferralStatus(id, statusId);
  }
}
