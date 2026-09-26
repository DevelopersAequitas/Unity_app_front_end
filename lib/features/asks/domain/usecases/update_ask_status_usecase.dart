import '../repositories/asks_repository.dart';

class UpdateAskStatusUseCase {
  final AsksRepository repository;

  UpdateAskStatusUseCase(this.repository);

  Future<bool> call({
    required String askId,
    required String status,
    int? statusId,
    String? outcomeStatus,
    String? approxValue,
    String? note,
    bool? shareStory,
    bool? anonymousTotal,
  }) {
    return repository.updateAskStatus(
      askId: askId,
      status: status,
      statusId: statusId,
      outcomeStatus: outcomeStatus,
      approxValue: approxValue,
      note: note,
      shareStory: shareStory,
      anonymousTotal: anonymousTotal,
    );
  }
}
