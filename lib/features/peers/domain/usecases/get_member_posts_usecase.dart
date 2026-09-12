import '../../../home/domain/entities/timeline_item_entity.dart';
import '../repositories/peers_repository.dart';

class GetMemberPostsUseCase {
  final PeersRepository repository;

  GetMemberPostsUseCase(this.repository);

  Future<List<TimelineItemEntity>> call(String memberId, {int page = 1}) {
    return repository.getMemberPosts(memberId, page: page);
  }
}
