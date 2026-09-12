import '../entities/timeline_item_entity.dart';
import '../entities/timeline_pagination_entity.dart';
import '../repositories/home_repository.dart';

class GetTimelineFeedUseCase {
  final HomeRepository repository;

  const GetTimelineFeedUseCase(this.repository);

  Future<({List<TimelineItemEntity> items, TimelinePaginationEntity pagination})>
  call({int page = 1, int perPage = 20, String? filter}) {
    return repository.getTimelineFeed(
      page: page,
      perPage: perPage,
      filter: filter,
    );
  }
}
