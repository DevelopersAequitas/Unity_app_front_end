import '../repositories/auth_repository.dart';

class RequestOtpUseCase {
  final AuthRepository _repository;

  const RequestOtpUseCase(this._repository);

  Future<void> call(String email, {String channel = 'email'}) {
    return _repository.requestOtp(email, channel: channel);
  }
}
