import '../repositories/home_repository.dart';

class TogglePostLikeUseCase {
  final HomeRepository repository;

  const TogglePostLikeUseCase(this.repository);

  Future<bool> call(String postId, {required bool isCurrentlyLiked}) {
    return repository.toggleLike(postId, isCurrentlyLiked: isCurrentlyLiked);
  }
}
