import '../entities/p2p_reschedule_request_entity.dart';
import '../entities/reschedule_p2p_meeting_params.dart';
import '../repositories/p2p_meetings_repository.dart';

class RequestRescheduleP2pMeetingUseCase {
  final P2pMeetingsRepository repository;
  const RequestRescheduleP2pMeetingUseCase(this.repository);

  Future<P2pRescheduleRequestEntity> call(
    String requestId,
    RescheduleP2pMeetingParams params,
  ) {
    return repository.requestReschedule(requestId, params);
  }
}
