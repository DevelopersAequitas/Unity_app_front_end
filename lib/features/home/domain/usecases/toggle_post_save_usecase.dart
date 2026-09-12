import '../repositories/home_repository.dart';

class TogglePostSaveUseCase {
  final HomeRepository repository;

  const TogglePostSaveUseCase(this.repository);

  Future<bool> call(String postId, {required bool isCurrentlySaved}) {
    return repository.toggleSave(postId, isCurrentlySaved: isCurrentlySaved);
  }
}
