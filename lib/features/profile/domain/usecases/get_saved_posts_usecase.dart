import '../../../home/domain/entities/timeline_item_entity.dart';
import '../repositories/profile_repository.dart';

class GetSavedPostsUseCase {
  final ProfileRepository repository;

  GetSavedPostsUseCase(this.repository);

  Future<List<TimelineItemEntity>> call({int page = 1}) {
    return repository.getSavedPosts(page: page);
  }
}
