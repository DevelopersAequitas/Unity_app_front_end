import '../repositories/p2p_meetings_repository.dart';

class ApproveRescheduleRequestUseCase {
  final P2pMeetingsRepository repository;
  const ApproveRescheduleRequestUseCase(this.repository);

  Future<void> call(String id) {
    return repository.approveRescheduleRequest(id);
  }
}
