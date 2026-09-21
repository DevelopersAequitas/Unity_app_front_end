import '../entities/entrepreneur_submissions_response_entity.dart';
import '../repositories/entrepreneur_certification_repository.dart';

class GetEntrepreneurCertificationSubmissionsUseCase {
  final EntrepreneurCertificationRepository repository;

  const GetEntrepreneurCertificationSubmissionsUseCase(this.repository);

  Future<EntrepreneurSubmissionsResponseEntity> call({int page = 1}) {
    return repository.getSubmissions(page: page);
  }
}
