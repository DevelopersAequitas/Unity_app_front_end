import 'dart:io';
import '../../domain/entities/claim_activity_entity.dart';
import '../../domain/entities/claim_coin_entity.dart';
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

  @override
  Future<List<ClaimActivityEntity>> getCoinClaimActivities() async {
    final models = await remoteDataSource.getCoinClaimActivities();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Map<String, dynamic>> submitCoinClaim({
    required String activityCode,
    required Map<String, dynamic> fields,
    File? proofFile,
  }) {
    return remoteDataSource.submitCoinClaim(
      activityCode: activityCode,
      fields: fields,
      proofFile: proofFile,
    );
  }

  @override
  Future<List<ClaimCoinEntity>> getMyCoinClaims({String? status}) async {
    final models = await remoteDataSource.getMyCoinClaims(status: status);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<String> uploadProofFile(File file) {
    return remoteDataSource.uploadProofFile(file);
  }
}
