import '../entities/p2p_reschedule_request_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class GetPendingRescheduleRequestsReceivedUseCase {
  final P2pMeetingsRepository repository;
  const GetPendingRescheduleRequestsReceivedUseCase(this.repository);

  Future<List<P2pRescheduleRequestEntity>> call() {
    return repository.getPendingRescheduleRequestsReceived();
  }
}
