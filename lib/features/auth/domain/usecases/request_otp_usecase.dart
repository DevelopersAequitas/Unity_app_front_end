import '../repositories/auth_repository.dart';

class RequestOtpUseCase {
  final AuthRepository _repository;

  const RequestOtpUseCase(this._repository);

  Future<void> call(String email) {
    return _repository.requestOtp(email);
  }
}
