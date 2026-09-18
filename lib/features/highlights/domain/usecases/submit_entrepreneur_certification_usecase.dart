import '../entities/entrepreneur_certification_result_entity.dart';
import '../repositories/entrepreneur_certification_repository.dart';

class SubmitEntrepreneurCertificationUseCase {
  final EntrepreneurCertificationRepository repository;
  const SubmitEntrepreneurCertificationUseCase(this.repository);

  Future<EntrepreneurCertificationResultEntity> call({
    required String fullName,
    required String businessName,
    required String email,
    required String contactNo,
    required Map<String, String> answers,
  }) {
    return repository.submitCertification(
      fullName: fullName,
      businessName: businessName,
      email: email,
      contactNo: contactNo,
      answers: answers,
    );
  }
}
