import '../entities/leadership_certification_result_entity.dart';
import '../repositories/leadership_certification_repository.dart';

class SubmitLeadershipCertificationUseCase {
  final LeadershipCertificationRepository repository;
  const SubmitLeadershipCertificationUseCase(this.repository);

  Future<LeadershipCertificationResultEntity> call({
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
