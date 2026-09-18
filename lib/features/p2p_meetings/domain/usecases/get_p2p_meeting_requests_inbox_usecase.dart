import '../entities/p2p_meeting_request_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class GetP2pMeetingRequestsInboxUseCase {
  final P2pMeetingsRepository repository;
  const GetP2pMeetingRequestsInboxUseCase(this.repository);

  Future<List<P2pMeetingRequestEntity>> call({String? status}) {
    return repository.getP2pMeetingRequestsInbox(status: status);
  }
}
