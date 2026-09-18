import '../entities/certification_question_entity.dart';
import '../repositories/leadership_certification_repository.dart';

class GetLeadershipCertificationQuestionsUseCase {
  final LeadershipCertificationRepository repository;
  const GetLeadershipCertificationQuestionsUseCase(this.repository);

  Future<List<CertificationQuestionEntity>> call() {
    return repository.getQuestions();
  }
}
