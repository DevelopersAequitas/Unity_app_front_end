import '../repositories/my_network_repository.dart';

class GetNetworkMembersUseCase {
  final MyNetworkRepository repository;
  const GetNetworkMembersUseCase(this.repository);

  Future<NetworkMembersPageResult> call({int page = 1}) =>
      repository.getNetworkMembers(page: page);
}
