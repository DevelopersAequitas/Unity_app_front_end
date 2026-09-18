import '../../domain/entities/certification_question_entity.dart';
import '../../domain/entities/entrepreneur_certification_result_entity.dart';
import '../../domain/repositories/entrepreneur_certification_repository.dart';
import '../datasources/entrepreneur_certification_remote_datasource.dart';

class EntrepreneurCertificationRepositoryImpl implements EntrepreneurCertificationRepository {
  final EntrepreneurCertificationRemoteDataSource remoteDataSource;

  const EntrepreneurCertificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CertificationQuestionEntity>> getQuestions() async {
    return await remoteDataSource.getQuestions();
  }

  @override
  Future<EntrepreneurCertificationResultEntity> submitCertification({
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
