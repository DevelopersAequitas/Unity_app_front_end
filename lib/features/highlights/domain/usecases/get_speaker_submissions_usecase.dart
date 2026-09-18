import '../entities/speaker_submission_entity.dart';
import '../repositories/speaker_repository.dart';

class GetSpeakerSubmissionsUseCase {
  final SpeakerRepository repository;

  const GetSpeakerSubmissionsUseCase(this.repository);

  Future<List<SpeakerSubmissionEntity>> call() async {
    return await repository.getSpeakerSubmissions();
  }
}
