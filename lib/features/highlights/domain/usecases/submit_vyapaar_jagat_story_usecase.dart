import '../entities/vyapaar_jagat_story_entity.dart';
import '../repositories/vyapaar_jagat_repository.dart';

class SubmitVyapaarJagatStoryUseCase {
  final VyapaarJagatRepository repository;

  const SubmitVyapaarJagatStoryUseCase(this.repository);

  Future<String> call(VyapaarJagatStoryEntity entity) async {
    return await repository.submitStory(entity);
  }
}
