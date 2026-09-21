import '../entities/event_item_entity.dart';
import '../repositories/register_visitor_repository.dart';

class GetEventsUseCase {
  final RegisterVisitorRepository repository;

  const GetEventsUseCase(this.repository);

  Future<List<EventItemEntity>> call() async {
    return await repository.getEvents();
  }
}
