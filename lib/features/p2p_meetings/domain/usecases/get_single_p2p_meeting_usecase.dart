import '../entities/p2p_meeting_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class GetSingleP2pMeetingUseCase {
  final P2pMeetingsRepository repository;
  const GetSingleP2pMeetingUseCase(this.repository);

  Future<P2pMeetingEntity> call(String id) {
    return repository.getSingleP2pMeeting(id);
  }
}
