import '../entities/mentor_submission_entity.dart';

abstract class MentorRepository {
  Future<List<MentorSubmissionEntity>> getMentorSubmissions();
  Future<String> submitMentorApplication(MentorSubmissionEntity entity);
}
