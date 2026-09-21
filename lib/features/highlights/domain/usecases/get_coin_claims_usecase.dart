import '../entities/claim_coin_entity.dart';
import '../repositories/coins_repository.dart';

class GetCoinClaimsUseCase {
  final CoinsRepository repository;
  const GetCoinClaimsUseCase(this.repository);

  Future<List<ClaimCoinEntity>> call({String? status}) {
    return repository.getMyCoinClaims(status: status);
  }
}
