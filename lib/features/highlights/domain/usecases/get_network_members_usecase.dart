import '../entities/network_member_entity.dart';
import '../repositories/my_network_repository.dart';

class GetNetworkMembersUseCase {
  final MyNetworkRepository repository;
  const GetNetworkMembersUseCase(this.repository);

  Future<List<NetworkMemberEntity>> call({int page = 1}) =>
      repository.getNetworkMembers(page: page);
}
