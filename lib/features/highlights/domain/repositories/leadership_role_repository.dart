import '../entities/leadership_interest_entity.dart';

abstract class LeadershipRoleRepository {
  Future<void> submitLeadershipInterest(LeadershipInterestEntity interest);
}
