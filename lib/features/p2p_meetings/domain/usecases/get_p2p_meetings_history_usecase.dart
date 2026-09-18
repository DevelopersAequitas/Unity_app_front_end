import '../entities/p2p_meeting_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class GetP2pMeetingsHistoryUseCase {
  final P2pMeetingsRepository repository;
  const GetP2pMeetingsHistoryUseCase(this.repository);

  Future<List<P2pMeetingEntity>> call({required String filter}) {
    return repository.getP2pMeetingsHistory(filter: filter);
  }
}
