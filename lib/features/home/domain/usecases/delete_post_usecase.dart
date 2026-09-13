import '../repositories/home_repository.dart';

class DeletePostUseCase {
  final HomeRepository repository;

  const DeletePostUseCase(this.repository);

  Future<void> call(String postId) {
    return repository.deletePost(postId);
  }
}
