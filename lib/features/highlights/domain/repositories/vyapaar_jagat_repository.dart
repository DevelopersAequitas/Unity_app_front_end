import '../entities/vyapaar_jagat_story_entity.dart';
import '../entities/vyapaar_jagat_story_status_entity.dart';

abstract class VyapaarJagatRepository {
  Future<VyapaarJagatStoryStatusEntity> getStoryStatus();
  Future<String> submitStory(VyapaarJagatStoryEntity entity);
}
