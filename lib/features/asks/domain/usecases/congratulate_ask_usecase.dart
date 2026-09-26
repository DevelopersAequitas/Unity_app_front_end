import '../repositories/asks_repository.dart';

class CongratulateAskUseCase {
  final AsksRepository repository;

  CongratulateAskUseCase(this.repository);

  Future<bool> call(String askId, {String? comment}) async {
    return await repository.congratulateAsk(askId, comment: comment);
  }
}
