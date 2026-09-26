import '../entities/ask_submission_entity.dart';
import '../repositories/asks_repository.dart';

class CreateAndPublishAskUseCase {
  final AsksRepository repository;

  CreateAndPublishAskUseCase({required this.repository});

  Future<String?> execute(AskSubmissionEntity submission) async {
    final askId = await repository.createAskDraft(submission);
    final targetId = askId ?? 'draft-${DateTime.now().millisecondsSinceEpoch}';
    await repository.saveAskFilters(askId: targetId, submission: submission);
    await repository.publishAsk(
      targetId,
      postToTimeline: submission.postToTimeline,
      submission: submission,
    );
    return targetId;
  }
}
