import '../entities/circle_member_entity.dart';
import '../repositories/circles_repository.dart';

class GetCircleMembersUseCase {
  final CirclesRepository repository;

  const GetCircleMembersUseCase(this.repository);

  Future<List<CircleMemberEntity>> call(String circleId) {
    return repository.getCircleMembers(circleId);
  }
}
