import '../repositories/p2p_meetings_repository.dart';

class RejectP2pMeetingRequestUseCase {
  final P2pMeetingsRepository repository;
  const RejectP2pMeetingRequestUseCase(this.repository);

  Future<void> call(String id) {
    return repository.rejectP2pMeetingRequest(id);
  }
}
