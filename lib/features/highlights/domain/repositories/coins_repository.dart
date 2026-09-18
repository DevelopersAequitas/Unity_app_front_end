import '../entities/coin_wallet_entity.dart';

abstract class CoinsRepository {
  Future<CoinWalletEntity> getCoinWalletData();
}
