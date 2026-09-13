import '../repositories/home_repository.dart';

class UpdatePostUseCase {
  final HomeRepository repository;

  const UpdatePostUseCase(this.repository);

  Future<void> call(String postId, {required String contentText}) {
    return repository.updatePost(postId, contentText: contentText);
  }
}
