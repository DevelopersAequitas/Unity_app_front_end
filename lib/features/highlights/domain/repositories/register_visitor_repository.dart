import '../entities/event_item_entity.dart';
import '../entities/register_visitor_entity.dart';

abstract class RegisterVisitorRepository {
  Future<void> submitRegisterVisitor(RegisterVisitorEntity entity);
  Future<List<RegisterVisitorEntity>> getRegisterVisitorSubmissions();
  Future<List<EventItemEntity>> getEvents();
}
