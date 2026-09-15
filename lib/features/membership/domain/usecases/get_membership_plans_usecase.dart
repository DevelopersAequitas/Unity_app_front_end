import '../entities/membership_plan_entity.dart';
import '../repositories/membership_repository.dart';

class GetMembershipPlansUseCase {
  final MembershipRepository repository;

  GetMembershipPlansUseCase(this.repository);

  Future<List<MembershipPlanEntity>> call() {
    return repository.getMembershipPlans();
  }
}
