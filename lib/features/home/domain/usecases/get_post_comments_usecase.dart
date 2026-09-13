import '../entities/post_comment_entity.dart';
import '../repositories/home_repository.dart';

class GetPostCommentsUseCase {
  final HomeRepository repository;

  GetPostCommentsUseCase(this.repository);

  Future<List<PostCommentEntity>> call(String postId, {int page = 1}) {
    return repository.getPostComments(postId, page: page);
  }
}
