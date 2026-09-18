import '../entities/vyapaar_jagat_story_status_entity.dart';
import '../repositories/vyapaar_jagat_repository.dart';

class GetVyapaarJagatStoryStatusUseCase {
  final VyapaarJagatRepository repository;

  const GetVyapaarJagatStoryStatusUseCase(this.repository);

  Future<VyapaarJagatStoryStatusEntity> call() async {
    return await repository.getStoryStatus();
  }
}
