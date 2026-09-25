import '../entities/referral_validation_entity.dart';
import '../repositories/auth_repository.dart';

class ValidateReferralCodeUseCase {
  final AuthRepository repository;

  const ValidateReferralCodeUseCase(this.repository);

  Future<ReferralValidationEntity> call(String code) {
    return repository.validateReferralCode(code);
  }
}
