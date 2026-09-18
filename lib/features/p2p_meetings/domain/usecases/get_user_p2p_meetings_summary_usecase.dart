import '../entities/p2p_meeting_user_summary_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class GetUserP2pMeetingsSummaryUseCase {
  final P2pMeetingsRepository repository;
  const GetUserP2pMeetingsSummaryUseCase(this.repository);

  Future<P2pMeetingUserSummaryEntity> call(
    String userId, {
    int perPage = 20,
  }) {
    return repository.getUserP2pMeetingsSummary(userId, perPage: perPage);
  }
}
