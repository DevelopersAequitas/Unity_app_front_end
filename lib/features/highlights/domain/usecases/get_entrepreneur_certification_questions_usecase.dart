import '../entities/certification_question_entity.dart';
import '../repositories/entrepreneur_certification_repository.dart';

class GetEntrepreneurCertificationQuestionsUseCase {
  final EntrepreneurCertificationRepository repository;
  const GetEntrepreneurCertificationQuestionsUseCase(this.repository);

  Future<List<CertificationQuestionEntity>> call() {
    return repository.getQuestions();
  }
}
