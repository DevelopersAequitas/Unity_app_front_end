import '../entities/mentor_submission_entity.dart';
import '../repositories/mentor_repository.dart';

class GetMentorSubmissionsUseCase {
  final MentorRepository repository;

  const GetMentorSubmissionsUseCase(this.repository);

  Future<List<MentorSubmissionEntity>> call() async {
    return await repository.getMentorSubmissions();
  }
}
