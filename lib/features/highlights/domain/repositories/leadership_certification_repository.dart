import '../entities/certification_question_entity.dart';
import '../entities/leadership_certification_result_entity.dart';
import '../entities/leadership_submissions_response_entity.dart';

abstract class LeadershipCertificationRepository {
  Future<List<CertificationQuestionEntity>> getQuestions();
  Future<LeadershipSubmissionsResponseEntity> getSubmissions({int page = 1});
  Future<LeadershipCertificationResultEntity> submitCertification({
    required String fullName,
    required String businessName,
    required String email,
    required String contactNo,
    required Map<String, String> answers,
  });
}

