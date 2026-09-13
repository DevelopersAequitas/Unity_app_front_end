import '../entities/post_comment_entity.dart';
import '../repositories/home_repository.dart';

class AddPostCommentUseCase {
  final HomeRepository repository;

  AddPostCommentUseCase(this.repository);

  Future<PostCommentEntity> call(String postId, String content) {
    return repository.addPostComment(postId, content);
  }
}
