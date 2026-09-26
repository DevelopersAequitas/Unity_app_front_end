import '../repositories/asks_repository.dart';

class ToggleSaveAskUseCase {
  final AsksRepository repository;

  ToggleSaveAskUseCase(this.repository);

  Future<bool> call(String askId) async {
    return await repository.toggleSaveAsk(askId);
  }
}
