import '../../domain/entities/mentor_submission_entity.dart';
import '../../domain/repositories/mentor_repository.dart';
import '../datasources/mentor_remote_datasource.dart';
import '../models/mentor_submission_model.dart';

class MentorRepositoryImpl implements MentorRepository {
  final MentorRemoteDataSource remoteDataSource;

  const MentorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MentorSubmissionEntity>> getMentorSubmissions() async {
    return await remoteDataSource.getSubmissions();
  }

  @override
  Future<String> submitMentorApplication(MentorSubmissionEntity entity) async {
    final model = MentorSubmissionModel.fromEntity(entity);
    return await remoteDataSource.submitApplication(model);
  }
}
