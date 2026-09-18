import '../entities/create_referral_params.dart';
import '../entities/referral_entity.dart';
import '../repositories/referrals_repository.dart';

class CreateReferralUseCase {
  final ReferralsRepository repository;

  CreateReferralUseCase(this.repository);

  Future<ReferralEntity> call(CreateReferralParams params) {
    return repository.createReferral(params);
  }
}
