import '../entities/mentor_submission_entity.dart';
import '../repositories/mentor_repository.dart';

class SubmitMentorApplicationUseCase {
  final MentorRepository repository;

  const SubmitMentorApplicationUseCase(this.repository);

  Future<String> call(MentorSubmissionEntity entity) async {
    return await repository.submitMentorApplication(entity);
  }
}
