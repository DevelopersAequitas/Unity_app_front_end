import '../entities/create_p2p_meeting_params.dart';
import '../entities/p2p_meeting_entity.dart';
import '../repositories/p2p_meetings_repository.dart';

class LogP2pMeetingUseCase {
  final P2pMeetingsRepository repository;
  const LogP2pMeetingUseCase(this.repository);

  Future<P2pMeetingEntity> call(CreateP2pMeetingParams params) {
    return repository.logP2pMeeting(params);
  }
}
