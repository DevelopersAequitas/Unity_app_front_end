import '../repositories/auth_repository.dart';

class RequestWhatsappOtpUseCase {
  final AuthRepository _repository;

  const RequestWhatsappOtpUseCase(this._repository);

  Future<void> call(String phone) {
    return _repository.requestWhatsappOtp(phone);
  }
}
