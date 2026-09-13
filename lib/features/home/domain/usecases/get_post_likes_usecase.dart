import '../entities/post_like_entity.dart';
import '../repositories/home_repository.dart';

class GetPostLikesUseCase {
  final HomeRepository repository;

  GetPostLikesUseCase(this.repository);

  Future<List<PostLikeEntity>> call(String postId, {int page = 1}) {
    return repository.getPostLikes(postId, page: page);
  }
}
