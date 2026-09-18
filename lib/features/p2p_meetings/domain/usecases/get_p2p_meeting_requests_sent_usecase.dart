import '../entities/p2p_meeting_request_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class GetP2pMeetingRequestsSentUseCase {
  final P2pMeetingsRepository repository;
  const GetP2pMeetingRequestsSentUseCase(this.repository);

  Future<List<P2pMeetingRequestEntity>> call() {
    return repository.getP2pMeetingRequestsSent();
  }
}
