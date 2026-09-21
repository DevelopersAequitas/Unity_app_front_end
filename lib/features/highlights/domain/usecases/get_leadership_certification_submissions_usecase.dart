import '../entities/leadership_submissions_response_entity.dart';
import '../repositories/leadership_certification_repository.dart';

class GetLeadershipCertificationSubmissionsUseCase {
  final LeadershipCertificationRepository repository;

  const GetLeadershipCertificationSubmissionsUseCase(this.repository);

  Future<LeadershipSubmissionsResponseEntity> call({int page = 1}) {
    return repository.getSubmissions(page: page);
  }
}
