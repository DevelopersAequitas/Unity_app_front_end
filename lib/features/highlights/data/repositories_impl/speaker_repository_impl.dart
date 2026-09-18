import 'dart:io';
import '../../domain/entities/speaker_submission_entity.dart';
import '../../domain/repositories/speaker_repository.dart';
import '../datasources/speaker_remote_datasource.dart';
import '../models/speaker_submission_model.dart';

class SpeakerRepositoryImpl implements SpeakerRepository {
  final SpeakerRemoteDataSource remoteDataSource;

  const SpeakerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SpeakerSubmissionEntity>> getSpeakerSubmissions() async {
    return await remoteDataSource.getSubmissions();
  }

  @override
  Future<String> submitSpeakerApplication({
    required SpeakerSubmissionEntity entity,
    File? imageFile,
  }) async {
    final model = SpeakerSubmissionModel.fromEntity(entity);
    return await remoteDataSource.submitApplication(
      model: model,
      imageFile: imageFile,
    );
  }
}
