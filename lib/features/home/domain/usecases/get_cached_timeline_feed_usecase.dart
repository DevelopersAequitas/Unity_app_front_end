import '../entities/timeline_item_entity.dart';
import '../entities/timeline_pagination_entity.dart';
import '../repositories/home_repository.dart';

class GetCachedTimelineFeedUseCase {
  final HomeRepository repository;

  GetCachedTimelineFeedUseCase(this.repository);

  Future<({List<TimelineItemEntity> items, TimelinePaginationEntity pagination})?> call() {
    return repository.getCachedTimelineFeed();
  }
}
