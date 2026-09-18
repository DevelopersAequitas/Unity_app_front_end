import '../../domain/entities/coin_wallet_entity.dart';
import '../../domain/repositories/coins_repository.dart';
import '../datasources/coins_remote_datasource.dart';

class CoinsRepositoryImpl implements CoinsRepository {
  final CoinsRemoteDataSource remoteDataSource;

  const CoinsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CoinWalletEntity> getCoinWalletData() async {
    final model = await remoteDataSource.getCoinWalletData();
    return model.toEntity();
  }
}
