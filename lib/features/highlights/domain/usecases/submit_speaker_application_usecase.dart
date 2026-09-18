import 'dart:io';
import '../entities/speaker_submission_entity.dart';
import '../repositories/speaker_repository.dart';

class SubmitSpeakerApplicationUseCase {
  final SpeakerRepository repository;

  const SubmitSpeakerApplicationUseCase(this.repository);

  Future<String> call({
    required SpeakerSubmissionEntity entity,
    File? imageFile,
  }) async {
    return await repository.submitSpeakerApplication(
      entity: entity,
      imageFile: imageFile,
    );
  }
}
