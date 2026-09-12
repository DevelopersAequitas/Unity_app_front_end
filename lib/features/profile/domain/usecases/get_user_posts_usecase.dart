import '../../../home/domain/entities/timeline_item_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserPostsUseCase {
  final ProfileRepository repository;

  GetUserPostsUseCase(this.repository);

  Future<List<TimelineItemEntity>> call({int page = 1}) {
    return repository.getUserPosts(page: page);
  }
}
