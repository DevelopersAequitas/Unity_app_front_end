import '../entities/auth_token_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  const VerifyOtpUseCase(this._repository);

  Future<({UserEntity user, AuthTokenEntity token})> call({
    required String email,
    required String otp,
    required String deviceName,
  }) {
    return _repository.verifyOtp(
      email: email,
      otp: otp,
      deviceName: deviceName,
    );
  }
}
