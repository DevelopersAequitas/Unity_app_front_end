import '../entities/certification_question_entity.dart';
import '../entities/entrepreneur_certification_result_entity.dart';
import '../entities/entrepreneur_submissions_response_entity.dart';

abstract class EntrepreneurCertificationRepository {
  Future<List<CertificationQuestionEntity>> getQuestions();
  Future<EntrepreneurSubmissionsResponseEntity> getSubmissions({int page = 1});
  Future<EntrepreneurCertificationResultEntity> submitCertification({
    required String fullName,
    required String businessName,
    required String email,
    required String contactNo,
    required Map<String, String> answers,
  });
}

