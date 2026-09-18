import '../entities/create_peer_referral_params.dart';
import '../repositories/referrals_repository.dart';

class SubmitPeerReferralUseCase {
  final ReferralsRepository repository;

  SubmitPeerReferralUseCase(this.repository);

  Future<void> call(CreatePeerReferralParams params) {
    return repository.submitPeerReferral(params);
  }
}
