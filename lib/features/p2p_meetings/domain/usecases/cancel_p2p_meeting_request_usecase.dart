import '../repositories/p2p_meetings_repository.dart';

class CancelP2pMeetingRequestUseCase {
  final P2pMeetingsRepository repository;
  const CancelP2pMeetingRequestUseCase(this.repository);

  Future<void> call(String id) {
    return repository.cancelP2pMeetingRequest(id);
  }
}
