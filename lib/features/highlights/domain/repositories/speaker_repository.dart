import 'dart:io';
import '../entities/speaker_submission_entity.dart';

abstract class SpeakerRepository {
  Future<List<SpeakerSubmissionEntity>> getSpeakerSubmissions();
  Future<String> submitSpeakerApplication({
    required SpeakerSubmissionEntity entity,
    File? imageFile,
  });
}
