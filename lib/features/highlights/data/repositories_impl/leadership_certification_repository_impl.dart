import '../../domain/entities/certification_question_entity.dart';
import '../../domain/entities/leadership_certification_result_entity.dart';
import '../../domain/entities/leadership_submissions_response_entity.dart';
import '../../domain/repositories/leadership_certification_repository.dart';
import '../datasources/leadership_certification_remote_datasource.dart';

class LeadershipCertificationRepositoryImpl implements LeadershipCertificationRepository {
  final LeadershipCertificationRemoteDataSource remoteDataSource;

  const LeadershipCertificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CertificationQuestionEntity>> getQuestions() async {
    return await remoteDataSource.getQuestions();
  }

  @override
  Future<LeadershipSubmissionsResponseEntity> getSubmissions({int page = 1}) async {
    return await remoteDataSource.getSubmissions(page: page);
  }

  @override
  Future<LeadershipCertificationResultEntity> submitCertification({
    required String fullName,
    required String businessName,
    required String email,
    required String contactNo,
    required Map<String, String> answers,
  }) async {
    final payload = {
      'full_name': fullName,
      'business_name': businessName,
      'email': email,
      'contact_no': contactNo,
      'answers': answers,
      ...answers,
    };
    return await remoteDataSource.submitCertification(payload);
  }
}

