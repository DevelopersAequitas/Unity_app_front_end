import '../entities/gratitude_script_entity.dart';

abstract class GratitudeScriptRepository {
  Future<GratitudeScriptEntity> getGratitudeScript();
  Future<GratitudeScriptEntity> saveGratitudeScript({
    required String progressWord,
    required String nextMonthGoal,
    String experienceStory = '',
  });
}

