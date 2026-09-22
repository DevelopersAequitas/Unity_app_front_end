import '../entities/auth_token_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyWhatsappOtpUseCase {
  final AuthRepository _repository;

  const VerifyWhatsappOtpUseCase(this._repository);

  Future<({UserEntity user, AuthTokenEntity token})> call({
    required String phone,
    required String otp,
    required String deviceName,
  }) {
    return _repository.verifyWhatsappOtp(
      phone: phone,
      otp: otp,
      deviceName: deviceName,
    );
  }
}
