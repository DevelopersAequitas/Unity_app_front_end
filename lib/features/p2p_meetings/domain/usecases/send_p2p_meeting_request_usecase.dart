import '../entities/create_p2p_meeting_request_params.dart';
import '../entities/p2p_meeting_request_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class SendP2pMeetingRequestUseCase {
  final P2pMeetingsRepository repository;
  const SendP2pMeetingRequestUseCase(this.repository);

  Future<P2pMeetingRequestEntity> call(CreateP2pMeetingRequestParams params) {
    return repository.sendP2pMeetingRequest(params);
  }
}
