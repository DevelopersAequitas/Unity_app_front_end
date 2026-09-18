import '../entities/coin_wallet_entity.dart';
import '../repositories/coins_repository.dart';

class GetCoinWalletDataUseCase {
  final CoinsRepository repository;
  const GetCoinWalletDataUseCase(this.repository);

  Future<CoinWalletEntity> call() => repository.getCoinWalletData();
}
