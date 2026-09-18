import '../entities/p2p_meeting_request_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class GetSingleP2pMeetingRequestUseCase {
  final P2pMeetingsRepository repository;
  const GetSingleP2pMeetingRequestUseCase(this.repository);

  Future<P2pMeetingRequestEntity> call(String id) {
    return repository.getSingleP2pMeetingRequest(id);
  }
}
