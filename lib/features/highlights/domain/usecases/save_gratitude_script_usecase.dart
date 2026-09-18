import '../entities/gratitude_script_entity.dart';
import '../repositories/gratitude_script_repository.dart';

class SaveGratitudeScriptUseCase {
  final GratitudeScriptRepository repository;
  const SaveGratitudeScriptUseCase(this.repository);

  Future<GratitudeScriptEntity> call({
    required String progressWord,
    required String nextMonthGoal,
    String experienceStory = '',
  }) =>
      repository.saveGratitudeScript(
        progressWord: progressWord,
        nextMonthGoal: nextMonthGoal,
        experienceStory: experienceStory,
      );
}

