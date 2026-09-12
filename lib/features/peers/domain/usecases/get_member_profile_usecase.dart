import '../../../profile/domain/entities/profile_entity.dart';
import '../repositories/peers_repository.dart';

class GetMemberProfileUseCase {
  final PeersRepository repository;

  GetMemberProfileUseCase(this.repository);

  Future<ProfileEntity> call(String memberId) {
    return repository.getMemberProfile(memberId);
  }
}
