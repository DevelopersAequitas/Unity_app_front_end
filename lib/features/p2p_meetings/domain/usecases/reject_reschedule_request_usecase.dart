import '../repositories/p2p_meetings_repository.dart';

class RejectRescheduleRequestUseCase {
  final P2pMeetingsRepository repository;
  const RejectRescheduleRequestUseCase(this.repository);

  Future<void> call(String id, {String? reason}) {
    return repository.rejectRescheduleRequest(id, reason: reason);
  }
}
