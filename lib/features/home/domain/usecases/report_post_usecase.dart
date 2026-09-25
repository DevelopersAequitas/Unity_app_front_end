import '../repositories/home_repository.dart';

class ReportPostUseCase {
  final HomeRepository repository;

  ReportPostUseCase(this.repository);

  Future<void> call(String postId, int reasonId) {
    return repository.reportPost(postId, reasonId);
  }
}
