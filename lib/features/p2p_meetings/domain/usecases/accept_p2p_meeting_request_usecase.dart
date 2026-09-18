import '../repositories/p2p_meetings_repository.dart';

class AcceptP2pMeetingRequestUseCase {
  final P2pMeetingsRepository repository;
  const AcceptP2pMeetingRequestUseCase(this.repository);

  Future<void> call(String id) {
    return repository.acceptP2pMeetingRequest(id);
  }
}
