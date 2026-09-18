import '../entities/leadership_interest_entity.dart';
import '../repositories/leadership_role_repository.dart';

class SubmitLeadershipInterestUseCase {
  final LeadershipRoleRepository repository;
  const SubmitLeadershipInterestUseCase(this.repository);

  Future<void> call(LeadershipInterestEntity interest) {
    return repository.submitLeadershipInterest(interest);
  }
}
