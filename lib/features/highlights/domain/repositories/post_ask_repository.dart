import '../entities/post_ask_entity.dart';

abstract class PostAskRepository {
  Future<List<PostAskEntity>> getMyAsks();
  Future<String> submitAsk(PostAskEntity ask);
  Future<void> completeAsk(String id, {String? subject});
}
